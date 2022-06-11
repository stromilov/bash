#!/bin/bash

my_path=$(pwd)/torgbox/ftp_data/FSA_data/
path1=$my_path/declaration/original/
path2=$my_path/certificate/original/
link1=https://fsa.gov.ru/opendata/7736638268-rds/data-20220603-structure-20220603.7z
link2=https://fsa.gov.ru/opendata/7736638268-rss/data-20220603-structure-20220603.7z

mkdir -p $my_path/{certificate,declaration}/{2020,2021,2022,original}
wget -P$path1 $link1
wget -P$path2 $link2
file1=$(ls $path1 | grep "7z$")
file2=$(ls $path2 | grep "7z$")

parsing ()
{
    INPUT=$1$2
    OLDIFS=$IFS
    IFS='|'
    count=0

    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

    while read id_decl reg_number decl_status decl_type date_beginning \
        date_finish declaration_scheme product_object_type_decl product_type \
        product_group product_name asproduct_info product_tech_reg \
        organ_to_certification_name organ_to_certification_reg_number \
        basis_for_decl old_basis_for_decl applicant_type person_applicant_type \
        applicant_ogrn applicant_inn applicant_name manufacturer_type \
        manufacturer_ogrn manufacturer_inn manufacturer_name

    do
	    echo "id_decl : $id_decl"
	    echo "reg_number : $reg_number"
	    echo "decl_status : $decl_status"
	    echo "decl_type : $decl_type"
	    echo "date_beginning : $date_beginning"
        echo "date_finish : $date_finish"
        echo "declaration_scheme : $declaration_scheme"
        echo "product_object_type_decl : $product_object_type_decl"
        echo "product_type : $product_type"
        echo "product_group : $product_group"
        echo "product_name : $product_name"
        echo "asproduct_info : $asproduct_info"
        echo "product_tech_reg : $product_tech_reg"
        echo "organ_to_certification_name : $organ_to_certification_name"
        echo "organ_to_certification_reg_number : $organ_to_certification_reg_number"
        echo "basis_for_decl : $basis_for_decl"
        echo "old_basis_for_decl : $old_basis_for_decl"
        echo "applicant_type : $applicant_type"
        echo "person_applicant_type : $person_applicant_type"
        echo "applicant_ogrn : $applicant_ogrn"
        echo "applicant_inn : $applicant_inn"
        echo "applicant_name : $applicant_name"
        echo "manufacturer_type : $manufacturer_type"
        echo "manufacturer_ogrn : $manufacturer_ogrn"
        echo "manufacturer_inn : $manufacturer_inn"
        echo "manufacturer_name : $manufacturer_name"
    done < $INPUT

    IFS=$OLDIFS
}

if [ -e $path1$file1.1 ]
    then 
        if cmp $path1$file1 $path1$file1.1 &> /dev/null
            then rm $path1$file1.1;
            else 
                rm $path1$file1
                mv $path1$file1.1 $path1$file1
                7z x $path1$file1 -o$path1
                rss=$(ls $path1 | grep "csv$")
                echo $rss
                #parsing $path1 $rss
        fi
    else
        7z x $path1$file1 -o$path1
        rss=$(ls $path1 | grep "csv$")
        echo $rss
        #parsing $path1 $rss
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
                echo $rss
                #parsing $path1 $rss
        fi
    else
        7z x $path2$file2 -o$path2
        rss=$(ls $path2 | grep "csv$")
        echo $rss
    #parsing $path1 $rss
fi
