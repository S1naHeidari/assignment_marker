#!/bin/bash

echo Hello to assignment marker
students_records_file='students.records'
weights_file='weights'
a1_marks_file='A1.marks'
a2_marks_file='A2.marks'
is_header=0
while IFS=, read -ra arr; do
    #print header
    if [ $is_header -eq 0 ];
    then

        printf "%s%s%s%s\n" "First name","Last name","Student Number","username","A1","A2","Total","Grade"
        let is_header++
        continue
    fi
    #print first 4 fields
    printf -v x "%s," "${arr[@]}"
    x=${x%,}
    echo -n "$x"

    #Store the username
    this_username=${arr[3]}

    #print this student's a1 mark
    this_a1='0'
    this_a1_flag=0
    while IFS=, read -ra arr_marks; do
        if [ "${arr_marks[0]}" = "$this_username" ];
        then
            this_a1=${arr_marks[1]}
            echo -n ",${arr_marks[1]}"
            let this_a1_flag++
            break
        fi
    done < $a1_marks_file

    if [ "$this_a1_flag" = 0 ]; then
        echo -n ",$this_a1"
    fi

    #print this student's a2 mark
    this_a2=0
    this_a2_flag=0
    while IFS=, read -ra arr_marks; do
        if [[ ${arr_marks[0]}=$this_username ]];
        then
            this_a2=${arr_marks[1]}
            echo -n ",${arr_marks[1]}"
            let this_a1_flag++
            break
        fi
    done < $a2_marks_file
    if [ "$this_a2_flag" = 0 ]; then
        echo -n ",$this_a2"
    fi


    #read weights file for a1 and a2
    is_header_w=0
    while IFS=, read -ra arr_weights; do
        if [ $is_header_w -eq 0 ];
        then
            let is_header_w++
            continue
        fi

        # if [ "${arr_weights[0]}" = "A1" ]; then
        #     echo ",${arr_weights[2]}"
        # fi
        if [ "${arr_weights[0]}" = "A1" ]
        then
            this_a1_weight=`echo ${arr_weights[2]} | sed 's/.$//'`
            echo -n ",$this_a1_weight"
        fi

        if [ "${arr_weights[0]}" = "A2" ]
        then
            this_a2_weight=`echo ${arr_weights[2]} | sed 's/.$//'`
            echo  ",$this_a2_weight"
        fi
    done < $weights_file

done < $students_records_file
