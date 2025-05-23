#!/bin/bash
path_lists=$1
path_models=$2
path_acc=$3

# list of the scenarii
declare -a tagmaps=('executable_classification'
                        'novelty_classification'
                        'packer_identification'
                        'virtualization_identification'
                        'family_classification'
                        'obfuscation_classification'
                        'type_classification')

declare -a MLP_bds=('12' '20' '28' '4' '16' '28' '12')
declare -a CNN_bds=('8' '20' '12' '4' '8' '16' '20')


# number of tagmaps
nb_of_tagmaps=${#tagmaps[@]}

for  (( i=0; i<${nb_of_tagmaps}; i++ ));
do
	echo "Computing MLP, tagmap: ${tagmaps[$i]}"
	python3 dl_analysis/evaluate.py --band ${MLP_bds[$i]} --list ${path_lists}/extracted_bd_files_lists_tagmaps=${tagmaps[$i]}.npy\
		--acc ${path_acc}\
	       	--model ${path_models}/MLP/${tagmaps[$i]}.h5
done



for  (( i=0; i<${nb_of_tagmaps}; i++ ));
do
    echo "Computing CNN, tagmap: ${tagmaps[$i]}"
    python3 dl_analysis/evaluate.py --band ${CNN_bds[$i]} --list ${path_lists}/extracted_bd_files_lists_tagmaps=${tagmaps[$i]}.npy\
	    --acc ${path_acc} --model ${path_models}/CNN/${tagmaps[$i]}.h5

done
