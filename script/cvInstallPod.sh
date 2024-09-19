export LANG=en_US.UTF-8
source ./cvPM.sh

os_sed=(-i)
case "$(uname)" in
  Darwin*) os_sed=(-i "")
esac

copyFileName="CP_Podfile"
cd $1
cp -p Podfile $copyFileName
lineIndex=0
targetIndex=0

while IFS= read -r line;
do
  $((lineIndex++))
  filterString "$line" "pod '"$2"'"
  result=$?;
  if [[ $result == 1 ]]; then
      delete="$lineIndex""d"
      sed "${os_sed[@]}" $delete Podfile
      lineIndex=$((lineIndex-1))
  fi

  filterString "$line" "pod '"
  podResult=$?;
  # 暂时只考虑一个target情况
  filterString "$line" "target '"
  tResult=$?;
  if [[ $podResult == 1 || $tResult == 1 ]]; then
    targetIndex=$lineIndex
  fi
done < Podfile

#对齐用
space="  "
if [[ $3 == "" ]]; then 
    input="pod '"''$2''"'"
else 
    input="pod '"''$2''"','"''$3''"'"
fi
      sed "${os_sed[@]}" ''$((targetIndex+1))'i\
'"$space"''"$input"'\
' Podfile
pResult=$(pod install)
filterString "$pResult" "Pod installation complete"
result=$?
if [[ $result == 1 ]]; then
  echo "1\c"
  rm $copyFileName
else
  echo $pResult
  cp -f $copyFileName Podfile
  rm $copyFileName
fi