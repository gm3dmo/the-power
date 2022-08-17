
turns=${1:-3}
for item in $(seq $turns)
do
  echo $item
  item_l=$(printf "%05d" $item)
  ./create-commit-status.sh ${item_l}
done
