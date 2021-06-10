import torch
import torch.nn as nn
import torchvision
import numpy as np
from torch.autograd import Variable
from torchvision.models import squeezenet1_1
import torch.functional as F
from io import open
import os
from PIL import Image
import pathlib
import glob
import cv2
from torchvision import transforms


def pred(image_path):

    device = "cpu"

    num_classes = 10
    lr = 0.001
    batch_size = 128
    num_epochs = 5

    def train_resnet18(device, num_classes):
        model = torchvision.models.resnet18(pretrained=True)

        for param in model.parameters():
            param.requires_grad = False

        model.layer4[1].conv2 = nn.Conv2d(
            in_channels=512, out_channels=512, kernel_size=3, stride=1, padding=1)
        model.fc = nn.Linear(512, num_classes, bias=True)

        model.to(device)

        return model

    checkpoint = torch.load("best_accuracy.model",
                            map_location=torch.device('cpu'))
    model = train_resnet18(device, num_classes)
    model.load_state_dict(checkpoint)
    model.eval()

    transformer = transforms.Compose([
        transforms.Resize((256, 256)),
        transforms.ToTensor(),  # 0-255 to 0-1, numpy to tensors
        transforms.Normalize([0.5, 0.5, 0.5],
                             [0.5, 0.5, 0.5])
    ])

    classes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    # prediction function

    def prediction(img_path, transformer):
        image = Image.open(img_path)
        image_tensor = transformer(image).float()
        image_tensor = image_tensor.unsqueeze_(0)

        input = Variable(image_tensor)
        output = model(input)
        index = output.data.numpy().argmax()

        pred = classes[index]
        return pred

    pred = prediction(image_path, transformer)

    print(pred)
