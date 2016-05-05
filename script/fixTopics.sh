for i in $(find . -type f)
do
	sed -i "s/-AH</identifier>/</identifier>/g" "$i";
done