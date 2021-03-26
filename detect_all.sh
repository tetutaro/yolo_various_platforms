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
        ./detect.py -m ${model} -f ${frame} -d ${dir}
    done
done
for quant in ${quants[@]} ; do
    for model in ${models[@]} ; do
        ./detect.py -m ${model} -f tflite -q ${quant} -d ${dir}
    done
done
