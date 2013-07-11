until ! read curLine
do
    desc=`echo "$curLine" | cut -d"|" -f1`
    url=`echo "$curLine" | cut -d"|" -f2`
    echo "<a href=\"${url}\">${desc}</a>" # >> output.txt
done
