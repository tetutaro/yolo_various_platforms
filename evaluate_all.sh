#!/usr/bin/env bash
if [ $# != 1 ]; then
    echo "Usage: $0 [dir]"
    exit 1
fi
dir=$1
if [ ! -d ${dir} ]; then
    echo "${dir} not found"
    exit 1
fi
datanames=(${dir//\// })
dataname=${datanames[${#datanames[@]}-1]}
models=(
    "yolov5s" "yolov5m" "yolov5l" "yolov5x"
)
frames=(
    "torch" "torch_onnx" "onnx_vino" "onnx_tf" "tf" "tf_onnx"
)
quants=(
    "fp32" "fp16"
)
for frame in ${frames[@]} ; do
    for model in ${models[@]} ; do
        object_detection_metrics -t ${dir}/ground_truths.jsonl -p results/${dataname}/${model}_${frame}/predictions.jsonl
    done
done
for quant in ${quants[@]} ; do
    for model in ${models[@]} ; do
        object_detection_metrics -t ${dir}/ground_truths.jsonl -p results/${dataname}/${model}_tflite_${quant}/predictions.jsonl
    done
done
