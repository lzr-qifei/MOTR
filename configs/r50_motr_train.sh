# ------------------------------------------------------------------------
# Copyright (c) 2021 megvii-model. All Rights Reserved.
# ------------------------------------------------------------------------
# Modified from Deformable DETR (https://github.com/fundamentalvision/Deformable-DETR)
# Copyright (c) 2020 SenseTime. All Rights Reserved.
# ------------------------------------------------------------------------

PRETRAIN=/home/mnt/lizirui/data/pretrained/r50_deformable_detr_plus_iterative_bbox_refinement-checkpoint.pth  
EXP_DIR=exps/e2e_motr_r50_joint 
# for MOT17
srun -p c7e6fad6-4dfa-42ef-af06-b0858c594d44 --workspace-id c75ef8a9-625f-4985-8c14-67b04e72a8c1 \
 -N 1 -f pt -d StandAlone -r N1lS.Ia.I20.8 -j MOTR_train_MOT17  \
bash -c 'export OMP_NUM_THREADS=1 && source activate /home/mnt/lizirui/envs/TrackTacular/  \
 && cp /home/mnt/share/lishuhuai/to_zirui/petreloss.conf /root \
&& python3 -m torch.distributed.launch --nproc_per_node=8 \
 --master_addr=127.0.0.1  \
--master_port=8089   \
--nnodes 1 \
    --use_env /home/mnt/lizirui/MOTR-main/main.py \
    --meta_arch motr \
    --use_checkpoint \
    --dataset_file e2e_joint \
    --epoch 200 \
    --with_box_refine \
    --lr_drop 100 \
    --lr 2e-4 \
    --lr_backbone 2e-5 \
    --pretrained /home/mnt/lizirui/data/pretrained/r50_deformable_detr_plus_iterative_bbox_refinement-checkpoint.pth  \
    --output_dir /home/mnt/lizirui/MOTR-main/exps/e2e_motr_r50_joint \
    --batch_size 1 \
    --sample_mode 'random_interval' \
    --sample_interval 10 \
    --sampler_steps 50 90 150 \
    --sampler_lengths 2 3 4 5 \
    --update_query_pos \
    --merger_dropout 0 \
    --dropout 0 \
    --random_drop 0.1 \
    --fp_ratio 0.3 \
    --query_interaction_layer 'QIM' \
    --extra_track_attn \
    --data_txt_path_train /home/mnt/lizirui/MOTR-main/datasets/data_path/joint.train \
    --data_txt_path_val /home/mnt/lizirui/MOTR-main/datasets/data_path/mot17.train '