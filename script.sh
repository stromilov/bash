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

#запомнить имена загруженных файлов
file1=$(ls $path1 | grep "7z$")
file2=$(ls $path2 | grep "7z$")


#функция парсинга для declaration
parsing_decl ()
{
    echo "\n-------парсинг $2 файла..."
    INPUT=$1$2
    OLDIFS=$IFS
    IFS='|'
    count=1
    glbcount=1
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
}" > $my_path/temp/declaration_20220603_$(printf %07d $glbcount).json

    glbcount=$((glbcount+1))
    count=$((count+1))

    #когда набирается 1000 json файлов они архивируются и удалются
    #архив переносится в свою папку
    if [ $count -eq 1000 ]
        then
            count=1
            7z a -mx0 -bd -sdel $my_path/temp/declaration_20220603_$(printf %03d $count_zip).7z $my_path/temp/.
            mv $my_path/temp/*.7z $my_path/declaration/2022/
            count_zip=$((count_zip+1))
    fi
    done < $INPUT

    #если строки в csv файле закончились и их меньше 1000 то оставшиеся
    #json файлы все равно архивируются
    7z a -mx0 -sdel $my_path/temp/declaration_20220603_$(printf %03d $count_zip).7z $my_path/temp/.
    mv $my_path/temp/*.7z $my_path/declaration/2022/
    rm $my_path/temp/*

    IFS=$OLDIFS
}


#функция парсинга для certificate
parsing_cert ()
{
    echo "парсинг $2 файла..."
    INPUT=$1$2
    OLDIFS=$IFS
    IFS='|'
    count=1
    glbcount=1
    count_zip=1


    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

    while read id_cert cert_status cert_type reg_number date_begining date_finish\
                product_scheme product_object_type_cert product_type product_okpd2\
                product_tn_ved product_tech_reg product_group product_name product_info\
                applicant_type person_applicant_type applicant_ogrn applicant_inn\
                applicant_phone applicant_fax applicant_email applicant_website\
                applicant_name applicant_director_name applicant_address applicant_address_actual\
                manufacturer_type manufacturer_ogrn manufacturer_inn manufacturer_phone\
                manufacturer_fax manufacturer_email manufacturer_website manufacturer_name\
                manufacturer_director_name manufacturer_country manufacturer_address\
                manufacturer_address_actual manufacturer_address_filial organ_to_certification_name\
                organ_to_certification_reg_number organ_to_certification_head_name\
                basis_for_certificate old_basis_for_certificate fio_expert fio_signatory\
                product_national_standart production_analysis_for_act production_analysis_for_act_number\
                production_analysis_for_act_date
    do
  
echo "{ 
    \"_type\":                              \"certificate\",
    \"id_cert\" :                            $id_cert,
    \"cert_status\" :                        $cert_status,
    \"cert_type\" :                          $cert_type,
    \"reg_number\" :                         $reg_number,
    \"date_begining\" :                      $date_begining,
    \"date_finish\" :                        $date_finish,
    \"product_scheme\" :                     $product_scheme,
    \"product_object_type_cert\" :           $product_object_type_cert,
    \"product_type\" :                       $product_type,
    \"product_okpd2\" :                      $product_okpd2,
    \"product_tn_ved\" :                     $product_tn_ved,
    \"product_tech_reg\" :                   $product_tech_reg,
    \"product_group\" :                      $product_group,
    \"product_name\" :                       $product_name,
    \"product_info\" :                       $product_info,
    \"applicant_type\" :                     $applicant_type,
    \"person_applicant_type\" :              $person_applicant_type,
    \"applicant_ogrn\" :                     $applicant_ogrn,
    \"applicant_inn\" :                      $applicant_inn,
    \"applicant_phone\" :                    $applicant_phone,
    \"applicant_fax\" :                      $applicant_fax,
    \"applicant_email\" :                    $applicant_email,
    \"applicant_website\" :                  $applicant_website,
    \"applicant_name\" :                     $applicant_name,
    \"applicant_director_name\" :            $applicant_director_name,
    \"applicant_address\" :                  $applicant_address,
    \"applicant_address_actual\" :           $applicant_address_actual,
    \"manufacturer_type\" :                  $manufacturer_type,
    \"manufacturer_ogrn\" :                  $manufacturer_ogrn,
    \"manufacturer_inn\" :                   $manufacturer_inn,
    \"manufacturer_phone\" :                 $manufacturer_phone,
    \"manufacturer_fax\" :                   $manufacturer_fax,
    \"manufacturer_email\" :                 $manufacturer_email,
    \"manufacturer_website\" :               $manufacturer_website,
    \"manufacturer_name\" :                  $manufacturer_name,
    \"manufacturer_director_name\" :         $manufacturer_director_name,
    \"manufacturer_country\" :               $manufacturer_country,
    \"manufacturer_address\" :               $manufacturer_address,
    \"manufacturer_address_actual\" :        $manufacturer_address_actual,
    \"manufacturer_address_filial\" :        $manufacturer_address_filial,
    \"organ_to_certification_name\" :        $organ_to_certification_name,
    \"organ_to_certification_reg_number\" :  $organ_to_certification_reg_number,
    \"organ_to_certification_head_name\" :   $organ_to_certification_head_name,
    \"basis_for_certificate\" :              $basis_for_certificate,
    \"old_basis_for_certificate\" :          $old_basis_for_certificate,
    \"fio_expert\" :                         $fio_expert,
    \"fio_signatory\" :                      $fio_signatory,
    \"product_national_standart\" :          $product_national_standart,
    \"production_analysis_for_act\" :        $production_analysis_for_act,
    \"production_analysis_for_act_number\" : $production_analysis_for_act_number,
    \"production_analysis_for_act_date\" :   $production_analysis_for_act_date
}" > $my_path/temp/certification_20220603_$(printf %07d $count).json

    glbcount=$((glbcount+1))
    count=$((count+1))

    #когда набирается 1000 json файлов они архивируются и удалются
    #архив переносится в свою папку
    if [ $count -eq 1000 ]
        then
            count=1
            7z a -mx0 -bd -sdel $my_path/temp/certificate_20220603_$(printf %03d $count_zip).7z $my_path/temp/.
            mv $my_path/temp/*.7z $my_path/certificate/2022/
            count_zip=$((count_zip+1))
    fi
    done < $INPUT

    #если строки в csv файле закончились и их меньше 1000 то оставшиеся
    #json файлы все равно архивируются
    7z a -mx0 -sdel $my_path/temp/certificate_20220603_$(printf %03d $count_zip).7z $my_path/temp/.
    mv $my_path/temp/*.7z $my_path/certificate/2022/

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
                echo "-----------------распаковка $file1 файла..."
                7z x $path1$file1 -o$path1
                rds=$(ls $path1 | grep "csv$")
                #функция парсинга файла
                parsing_decl $path1 $rds
        fi
    else #если он скачался впервые просто распаковывается
        7z x $path1$file1 -o$path1
        rds=$(ls $path1 | grep "csv$")
        #и парсится
        parsing_decl $path1 $rds
fi

if [ -e $path2$file2.1 ]
    then 
        if cmp $path2$file2 $path2$file2.1 &> /dev/null
            then rm $path2$file2.1;
            else 
                rm $path2$file2
                mv $path2$file2.1 $path2$file2
                echo "----------------распаковка $file2 файла..."
                7z x $path2$file2 -o$path2
                rss=$(ls $path2 | grep "csv$")
                parsing_cert $path2 $rss
        fi
    else
        7z x $path2$file2 -o$path2
        rss=$(ls $path2 | grep "csv$")
        parsing_cert $path2 $rss
fi

rm -r $my_path/temp
