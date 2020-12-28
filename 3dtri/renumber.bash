a=1
for i in render*png ; do
  new=$(printf "render%05d.png" "$a")
  #echo Moving "$i" to "$new"
  mv -f  -- "$i" "$new"
  let a=a+1
done
