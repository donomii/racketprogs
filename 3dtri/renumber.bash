a=1
for i in side_1_*png ; do
  new=$(printf "side_1_%05d.png" "$a")
  #echo Moving "$i" to "$new"
  mv -f  -- "$i" "$new"
  let a=a+1
done
