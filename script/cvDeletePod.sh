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

while read line
do
    $((lineIndex++))
    filterString "$line" "pod '"$2"'"
    result=$?
    if [[ $result == 1 ]]; then
        delete="$lineIndex""d"
        sed "${os_sed[@]}" $delete Podfile
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
        break;
    fi
done < Podfile

