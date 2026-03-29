#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import os

def create_notepad_icon(size):
    """创建类似 Windows 记事本的图标"""
    # 创建带透明度的 RGBA 图像
    img = Image.new('RGBA', (size, size), (255, 255, 255, 0))
    draw = ImageDraw.Draw(img)

    s = size  # 尺寸缩放因子

    # 阴影
    shadow_rect = [int(s * 0.1 + 4), int(s * 0.1 + 4), int(s * 0.9), int(s * 0.9)]
    draw.rounded_rectangle(shadow_rect, radius=int(s * 0.06), fill=(0, 0, 0, 50))

    # 白色记事本背景
    notebook_rect = [int(s * 0.1), int(s * 0.1), int(s * 0.9), int(s * 0.9)]
    draw.rounded_rectangle(notebook_rect, radius=int(s * 0.06), fill=(255, 255, 255, 255))

    # 灰色边框
    draw.rounded_rectangle(notebook_rect, radius=int(s * 0.06), outline=(180, 180, 180, 180), width=int(s * 0.01))

    # 装订线（左侧）
    spine_rect = [int(s * 0.12), int(s * 0.15), int(s * 0.135), int(s * 0.85)]
    draw.rectangle(spine_rect, fill=(180, 180, 180, 180))

    # 装订孔
    hole_size = int(s * 0.025)
    # 上孔
    draw.ellipse([int(s * 0.1), int(s * 0.28 - hole_size/2), int(s * 0.1 + hole_size), int(s * 0.28 + hole_size/2)], fill=(150, 150, 150, 255))
    # 下孔
    draw.ellipse([int(s * 0.1), int(s * 0.72 - hole_size/2), int(s * 0.1 + hole_size), int(s * 0.72 + hole_size/2)], fill=(150, 150, 150, 255))

    # 文本行
    start_x = int(s * 0.22)
    line_height = int(s * 0.025)
    line_spacing = int(s * 0.06)
    text_width = int(s * 0.45)
    text_y = int(s * 0.25)

    for i in range(5):
        y = text_y + i * (line_height + line_spacing)
        # 第一行
        draw.rectangle([start_x, y, start_x + text_width, y + line_height], fill=(180, 180, 180, 255))
        # 第二行
        draw.rectangle([start_x, y + line_height + int(s * 0.015), start_x + int(text_width * 0.75), y + line_height + int(s * 0.015) + line_height], fill=(180, 180, 180, 255))

    # 蓝色笔（右下角）
    pen_x = int(s * 0.75)
    pen_y = int(s * 0.65)
    pen_width = int(s * 0.025)
    pen_height = int(s * 0.2)

    # 简化的笔（旋转的矩形）
    import math
    angle = math.radians(15)

    # 笔杆
    pen_length = pen_height
    for offset in range(-int(pen_width/2), int(pen_width/2)):
        for y_offset in range(pen_height):
            # 旋转坐标变换
            rx = offset * math.cos(angle) - y_offset * math.sin(angle) + pen_x
            ry = offset * math.sin(angle) + y_offset * math.cos(angle) + pen_y
            if 0 <= rx < size and 0 <= ry < size:
                img.putpixel((int(rx), int(ry)), (0, 100, 220, 255))

    # 笔尖
    tip_rect = [pen_x - int(pen_width), pen_y + pen_height, pen_x + int(pen_width * 0.5), pen_y + pen_height + int(s * 0.025)]
    draw.rectangle(tip_rect, fill=(0, 100, 200, 255))

    # 笔头
    head_rect = [pen_x - int(pen_width), pen_y + int(s * 0.015), pen_x + int(pen_width * 0.75), pen_y + int(s * 0.015) + int(s * 0.03)]
    draw.rectangle(head_rect, fill=(0, 100, 180, 255))

    return img

# 保存图标
output_path = "/Users/feng/Work/tmp/3322/MacNotepadApp/MacNotepadApp/Resources/Assets.xcassets/AppIcon.appiconset/"

print("🎨 Generating Notepad icons...")

# 生成 512x512 的大图，然后缩放
large_icon = create_notepad_icon(512)
large_icon.save(output_path + "icon_512x512.png")
large_icon.save(output_path + "icon_512x512@2x.png")

# 生成其他尺寸
sizes = [256, 128, 32, 16]
for size in sizes:
    # 缩放图像
    img = large_icon.resize((size, size), Image.LANCZOS)
    img.save(output_path + f"icon_{size}x{size}.png")
    img.save(output_path + f"icon_{size}x{size}@2x.png")
    print(f"  ✓ {size}x{size}")

print("\n✅ Icons generated successfully!")
print(f"📁 Location: {output_path}")
