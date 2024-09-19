source ./cvPM.sh
cd $1
file="Podfile.lock"
initDic
initArray
awk '/\([0-9.]+\)/' $file > cv_temp_file.txt
while IFS= read -r line;do
        filterString "$line" "/"
        sCon=$?;
        if [[ $sCon == 0 ]]; then
            podName="${line#*-}"
            podName="${podName%%(*}"
            version="${line#*(}"
            version="${version%%)*}"
            podName=$(deleteTStr $podName '"')
            addKeyValue "name" $podName
            addKeyValue "version" $version
            addObj $dic
            clearDic
        fi
done < cv_temp_file.txt
rm cv_temp_file.txt
echo $ary

