#!/bin/bash

echo Hello to assignment marker
students_records_file=$1
weights_file=$2
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
        fi

        if [ "${arr_weights[0]}" = "A2" ]
        then
            this_a2_weight=`echo ${arr_weights[2]} | sed 's/.$//'`
        fi
    done < $weights_file

    #print this student's a1 mark
    this_a1='0'
    this_a1_flag=0
    while IFS=, read -ra arr_marks; do
        if [ "${arr_marks[0]}" = "$this_username" ];
        then
            this_a1=${arr_marks[1]}
            #here
            echo -n ","
            result1=`echo "scale=1;($this_a1*$this_a1_weight)/100"|bc`
            echo -n "$result1"
            let this_a1_flag++
            break
        fi
    done < $a1_marks_file

    if [ "$this_a1_flag" = 0 ]; then
        echo -n ",$this_a1"
        result1="0"
    fi

    #print this student's a2 mark
    this_a2=0
    this_a2_flag=0
    while IFS=, read -ra arr_marks; do
        if [[ ${arr_marks[0]}=$this_username ]];
        then
            this_a2=${arr_marks[1]}
            echo -n ","
            result2=`echo "scale=1;($this_a2*$this_a2_weight)/100"|bc`
            echo -n "$result2"
            let this_a2_flag++
            break
        fi
    done < $a2_marks_file
    if [ "$this_a2_flag" = 0 ]; then
        echo -n ",$this_a2"
        result2="0"
    fi

    #print total
    total=`echo "scale=1;$result1+$result2"|bc`
    echo -n ",$total"

    #print grade
    if (( $(echo "$total < 40" |bc -l) ));
    then
        echo ",F"
    elif (( $(echo "$total < 50" |bc -l) ));
    then
        echo ",E"
    elif (( $(echo "$total < 55" |bc -l) ));
    then
        echo ",D"
    elif (( $(echo "$total < 60" |bc -l) ));
    then
        echo ",D+"
    elif (( $(echo "$total < 65" |bc -l) ));
    then
        echo ",C"
    elif (( $(echo "$total < 70" |bc -l) ));
    then
        echo ",C+"
    elif (( $(echo "$total < 75" |bc -l) ));
    then
        echo ",B"
    elif (( $(echo "$total < 80" |bc -l) ));
    then
        echo ",B+"
    elif (( $(echo "$total < 90" |bc -l) ));
    then
        echo ",A"
    elif (( $(echo "$total < 100" |bc -l) ));
    then
        echo ",A+"
    fi


done < $students_records_file
