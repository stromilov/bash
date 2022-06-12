#!/bin/bash

my_path=$(pwd)/torgbox/ftp_data/FSA_data
path1=$my_path/declaration/original/
path2=$my_path/certificate/original/
link1=https://fsa.gov.ru/opendata/7736638268-rds/data-20220603-structure-20220603.7z
link2=https://fsa.gov.ru/opendata/7736638268-rss/data-20220603-structure-20220603.7z

mkdir -p $my_path/{certificate,declaration}/{2020,2021,2022,original}

#временная папка для json файлов
mkdir -p $my_path/temp

#загрузка архивов с сайта fsa.gov.ru
wget -P$path1 $link1
wget -P$path2 $link2

file1=$(ls $path1 | grep "7z$")
file2=$(ls $path2 | grep "7z$")


#функция парсинга для declaration
parsing_decl ()
{
    INPUT=$1$2
    OLDIFS=$IFS
    IFS='|'
    count=1
    count_zip=1


    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

    while read id_decl reg_number decl_status decl_type date_beginning \
        date_finish declaration_scheme product_object_type_decl product_type \
        product_group product_name asproduct_info product_tech_reg \
        organ_to_certification_name organ_to_certification_reg_number \
        basis_for_decl old_basis_for_decl applicant_type person_applicant_type \
        applicant_ogrn applicant_inn applicant_name manufacturer_type \
        manufacturer_ogrn manufacturer_inn manufacturer_name

    do
  
echo "{ 
    \"_type\":                              \"declaration\",
    \"id_decl\" :                           $id_decl,
    \"reg_number\" :                        $reg_number,
    \"decl_status\" :                       $decl_status,
    \"decl_type\" :                         $decl_type,
    \"date_beginning\" :                    $date_beginning,
    \"date_finish\" :                       $date_finish,
    \"declaration_scheme\" :                $declaration_scheme,
    \"product_object_type_decl\" :          $product_object_type_decl,
    \"product_type\" :                      $product_type,
    \"product_group\" :                     $product_group,
    \"product_name\" :                      $product_name,
    \"asproduct_info\" :                    $asproduct_info,
    \"product_tech_reg\" :                  $product_tech_reg,
    \"organ_to_certification_name\" :       $organ_to_certification_name,
    \"organ_to_certification_reg_number\" : $organ_to_certification_reg_number,
    \"basis_for_decl\" :                    $basis_for_decl,
    \"old_basis_for_decl\" :                $old_basis_for_decl,
    \"applicant_type\" :                    $applicant_type,
    \"person_applicant_type\" :             $person_applicant_type,
    \"applicant_ogrn\" :                    $applicant_ogrn,
    \"applicant_inn\" :                     $applicant_inn,
    \"applicant_name\" :                    $applicant_name,
    \"manufacturer_type\" :                 $manufacturer_type,
    \"manufacturer_ogrn\" :                 $manufacturer_ogrn,
    \"manufacturer_inn\" :                  $manufacturer_inn,
    \"manufacturer_name\" :                 $manufacturer_name
}" > $my_path/temp/declaration_20220603_$count.json

    count=$((count+1))

    #когда набирается 1000 json файлов они архивируются и удалются
    #архив переносится в свою папку
    if [ $count -eq 1000 ]
        then
            count=1
            7z a -mx0 $my_path/temp/declaration_20220603_$count_zip.7z $my_path/temp/.
            mv $my_path/temp/*.7z $my_path/declaration/2022/
            rm $my_path/temp/*
            count_zip=$((count_zip+1))
    fi
    done < $INPUT

    #если строки в csv файле закончились и их меньше 1000 то оставшиеся
    #json файлы все равно архивируются
    7z a -mx0 $my_path/temp/declaration_20220603_$count_zip.7z $my_path/temp/.
    mv $my_path/temp/*.7z $my_path/declaration/2022/

    IFS=$OLDIFS
}


#функция парсинга для certification
parsing_cert ()
{
    INPUT=$1$2
    OLDIFS=$IFS
    IFS='|'
    count=1
    count_zip=1


    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

    while read id_decl reg_number decl_status decl_type date_beginning \
        date_finish declaration_scheme product_object_type_decl product_type \
        product_group product_name asproduct_info product_tech_reg \
        organ_to_certification_name organ_to_certification_reg_number \
        basis_for_decl old_basis_for_decl applicant_type person_applicant_type \
        applicant_ogrn applicant_inn applicant_name manufacturer_type \
        manufacturer_ogrn manufacturer_inn manufacturer_name

    do
  
echo "{ 
    \"_type\":                              \"declaration\",
    \"id_decl\" :                           $id_decl,
    \"reg_number\" :                        $reg_number,
    \"decl_status\" :                       $decl_status,
    \"decl_type\" :                         $decl_type,
    \"date_beginning\" :                    $date_beginning,
    \"date_finish\" :                       $date_finish,
    \"declaration_scheme\" :                $declaration_scheme,
    \"product_object_type_decl\" :          $product_object_type_decl,
    \"product_type\" :                      $product_type,
    \"product_group\" :                     $product_group,
    \"product_name\" :                      $product_name,
    \"asproduct_info\" :                    $asproduct_info,
    \"product_tech_reg\" :                  $product_tech_reg,
    \"organ_to_certification_name\" :       $organ_to_certification_name,
    \"organ_to_certification_reg_number\" : $organ_to_certification_reg_number,
    \"basis_for_decl\" :                    $basis_for_decl,
    \"old_basis_for_decl\" :                $old_basis_for_decl,
    \"applicant_type\" :                    $applicant_type,
    \"person_applicant_type\" :             $person_applicant_type,
    \"applicant_ogrn\" :                    $applicant_ogrn,
    \"applicant_inn\" :                     $applicant_inn,
    \"applicant_name\" :                    $applicant_name,
    \"manufacturer_type\" :                 $manufacturer_type,
    \"manufacturer_ogrn\" :                 $manufacturer_ogrn,
    \"manufacturer_inn\" :                  $manufacturer_inn,
    \"manufacturer_name\" :                 $manufacturer_name
}" > $my_path/temp/declaration_20220603_$count.json

    count=$((count+1))

    #когда набирается 1000 json файлов они архивируются и удалются
    #архив переносится в свою папку
    if [ $count -eq 1000 ]
        then
            count=1
            7z a -mx0 $my_path/temp/declaration_20220603_$count_zip.7z $my_path/temp/.
            mv $my_path/temp/*.7z $my_path/declaration/2022/
            rm $my_path/temp/*
            count_zip=$((count_zip+1))
    fi
    done < $INPUT

    #если строки в csv файле закончились и их меньше 1000 то оставшиеся
    #json файлы все равно архивируются
    7z a -mx0 $my_path/temp/declaration_20220603_$count_zip.7z $my_path/temp/.
    mv $my_path/temp/*.7z $my_path/declaration/2022/

    IFS=$OLDIFS
}


#если новый файл скачался 
if [ -e $path1$file1.1 ]
    then #и побайтно совпадает со старым
        if cmp $path1$file1 $path1$file1.1 &> /dev/null
            then #тогда он удаляется
                rm $path1$file1.1
            else #иначе заменяет старый и распаковывается
                rm $path1$file1
                mv $path1$file1.1 $path1$file1
                7z x $path1$file1 -o$path1
                rds=$(ls $path1 | grep "csv$")
                #функция парсинга файла
                parsing1 $path1 $rds
        fi
    else #если он скачался впервые просто распаковывается
        7z x $path1$file1 -o$path1
        rds=$(ls $path1 | grep "csv$")
        #и парсится
        parsing1 $path1 $rds
fi

if [ -e $path2$file2.1 ]
    then 
        if cmp $path2$file2 $path2$file2.1 &> /dev/null
            then rm $path2$file2.1;
            else 
                rm $path2$file2
                mv $path2$file2.1 $path2$file2
                7z x $path2$file2 -o$path2
                rss=$(ls $path2 | grep "csv$")
                #parsing2 $path1 $rss
        fi
    else
        7z x $path2$file2 -o$path2
        rss=$(ls $path2 | grep "csv$")
    #parsing2 $path1 $rss
fi
