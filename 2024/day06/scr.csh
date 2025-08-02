#! /usr/bin/tcsh

cat $1 | sed 's/ */ /g' > path_dir.txt

set possible_dirs = ( '>' 'v' '<' '^' )
set next_possible_dir = ('v' '<' '^' '>' )

set curr_dir = `cat path_dir.txt | grep -o '>\|<\|\^\|v'`

while ( "${curr_dir}" != "" )
    if ( "${curr_dir}" == "^" ) then 
       set curr_dir_patt = "\"${curr_dir}
    else
       set curr_dir_patt = ${curr_dir}
    endif

    set num = `echo $possible_dirs | sed 's/ /\n/g' | grep -n '.' | grep "${curr_dir_patt}" | awk -F ':' '{print $1}'`
    echo $num
    set next_dir = $next_possible_dir[$num]
    echo "check1: curr_dir:${curr_dir} num:${num} next_dir:${next_dir}"
    if ( "$curr_dir" == ">" || "$curr_dir" == "<" ) then
       set file = 'path_dir.txt'
    else
       cat path_dir.txt | datamash -t ' ' transpose > transposed_pathDir.txt
       set file = 'transposed_pathDir.txt'
    endif
    
    echo "$file"
    cat $file
    echo " "
    echo "check2"
    if ( "$curr_dir" == "^" || "$curr_dir" == "<" ) then
       set rev_flag = 1
       set pattern = "${curr_dir_patt}"'\([^#]*\)\#'
       #set pattern = "\(.*\)\#\([^${curr_dir}]*\)${curr_dir}"
       set rep_string = "s/\# X/\# ${next_dir}/g"
    else
       set rev_flag = 0
       set pattern = "${curr_dir_patt}"'\([^#]*\)\#'
       set rep_string = "s/X \#/${next_dir} \#/g"
    endif
    
    echo "check3:: curr_dir:${curr_dir}:: pattern:${pattern}:: rep_string:${rep_string}"
    
    if ( $rev_flag ) then
       set to_replace = `cat $file | grep "${curr_dir_patt}" | rev | grep -o "$pattern"  | rev | sed "s/\.\|${curr_dir_patt}/X/g"  | sed "${rep_string}" | rev`
       cat $file | grep "${curr_dir_patt}" | rev | grep -o "$pattern" | rev | sed "s/\.\|${curr_dir_patt}/X/g" 
       cat $file | grep "${curr_dir_patt}" | rev | grep -o "$pattern" 
    else
       set to_replace = `cat $file | grep -o "$pattern" | sed "s/\.\|${curr_dir_patt}/X/g"  | sed "${rep_string}"`
       cat $file | grep -o "$pattern" | sed "s/\.\|${curr_dir_patt}/X/g" 
       cat $file | grep -o "$pattern" 
    endif

    if ( "${to_replace}" == "" ) then
       set pattern = `echo "$pattern" | sed 's/\\\#//g'`
       set to_replace = `cat $file | grep -o "$pattern" | sed "s/\.\|${curr_dir_patt}/X/g"  | sed "${rep_string}"`
    endif

    
    echo "check4: $to_replace"

    if ( $rev_flag ) then
       cat $file | rev | sed "s/$pattern/$to_replace/g" | rev > tmp_${file}
       \mv tmp_${file} ${file}
    else
       sed -i "s/$pattern/$to_replace/g" $file
    endif
    
    if ( $file == "transposed_pathDir.txt" ) then
       cat $file | datamash -t ' ' transpose > path_dir.txt
    endif
    
    cat path_dir.txt
    echo " "
    set curr_dir = `cat path_dir.txt | grep -o '>\|<\|\^\|v'`
    echo "end: $curr_dir"
end
