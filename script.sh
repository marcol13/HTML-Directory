#!/bin/bash
list=()
#section=("images","music","documents")
#ext=('d1=("jpg" "gif" "png" "jpeg" "tiff" "apng" "bmp" "ico" "cur" "jfif" "pjpeg" "pjp" "svg" "tif" "webp")' 'd2=("mp3" "ogg" "wav")' 'd3=("pdf" "doc" "odt")')
#for i in "${ext[@]}";do eval $i;done


function create_section(){
    text="<section id=\"$name\">
            <h2 class=\"section-title\">$desc</h2>
        </section>"
}

x="$(echo $1 | head -c 1)"
if [[ "$x" == "-" ]]
then
    case "$1" in
        "-h") echo "tu będzie pomoc";;
        "-a") echo "tu będzie można dodać kategorię";;
        "-d") echo "tu będzie można usunąć kategorię";;
        "--ae") echo "tu będzie można dodać rozszerzenie";;
        "--de") echo "tu będzie można usunąć rozszerzenie";;
        *) echo "Nie ma takiej flagi";;
    esac
else
    for i in $@
    do
        #echo "./$i" 
        if [ -a "./$i" ]
        then
            list+=(`find "./$i" -type f | grep '^\.\/.*\.\S*$' | sed -E "s/(\.\/)+//"`)
        else
            echo "$i - nie ma takiego pliku/katalogu"
        fi
    done
    list=( `for i in ${list[@]}; do echo $i; done | sort -u` )

    
    name=( `awk '{print $1}' extension.txt` )
    description=( `awk '{print $2}' extension.txt` )
    ext=( `awk '{print $3}' extension.txt` )
    #sed -E "s/,/ /g"
    n=${#name[@]}
    for i in $(seq 0 $(($n-1)))
    do
        temp_arr=(`echo ${ext[$i]} | sed -E "s/,/ /g" | sed -E "s/\"//g"`)
        #for j in ${list[@]}; do echo $j;done;
        temp_files=()
        for j in ${list[@]}
        do
            for k in ${temp_arr[@]}
            do 
                temp_files+=(`echo $j | grep -E "^.*\.$k$"`)
            done
        done
        #temp_files=(`for j in ${list[@]}; do echo $j | grep -E "^.*\.$temp_arr$";done`)
        for j in ${temp_files[@]}
        do
            time=`ls --full-time $j | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}"`
            path=`pwd`/$j
            echo $path
        done
        echo $i, ${temp_files[@]}
    done

    #echo ${ext[1]}
    echo ${list[0]}
fi

