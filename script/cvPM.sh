# 字符串包含目标字符串，包含 1，不包含0
function filterString() {
    result=$(echo $1 | grep "$2")
    if [[ $result != "" ]]; then
        return 1
    fi
    return 0
}

initDic() {
  dic="{}"
  addKeyValue() {
     key=$1
     value=$2
     dic=${dic:1}
     dic=${dic%?}
     keyValue='"'$key'":"'$value'"'
     if  [ -z "$dic" ]; then
          dic=$keyValue
     else
          dic=''$dic','$keyValue''
     fi
     dic='{'${dic}'}'
   }
   clearDic() {
     dic="{}"
   }
}

initArray() {
  ary="[]"
  addObj() {
    item=$1
    ary=${ary:1}
    ary=${ary%?}
    if  [ -z "$ary" ]; then
      ary="$item"
    else
      ary="$ary"",""$item"
    fi
    ary="[""$ary""]"
  }
  clearArr() {
    ary="[]"
  }
}

deleteTStr() {
   deleteC="echo '$1'"
   for i in $(seq 2 $#)
   do
    deleteC="$deleteC | sed 's/${!i}//g'"
   done
   eval $deleteC
}
