#!/bin/bash
# Figma 이미지 다운로드 스크립트
# 로컬 PC에서 실행하세요

mkdir -p images

echo "=== Figma 이미지 다운로드 시작 ==="

# Hero banner
curl -L -o images/hero-banner.jpg "https://www.figma.com/api/mcp/asset/e0e9b385-1762-49f6-bf1e-5accba3984b7"

# Collection banners (3-grid)
curl -L -o images/collection-new-arrivals.jpg "https://www.figma.com/api/mcp/asset/be060234-6880-4868-888e-2e80c349dce3"
curl -L -o images/collection-casual-edit.jpg "https://www.figma.com/api/mcp/asset/4099e981-991c-4b92-b07d-185e5a0b1acc"
curl -L -o images/collection-best-sellers.jpg "https://www.figma.com/api/mcp/asset/b459d0df-e8df-4658-ae15-1a1100c43158"

# Products
curl -L -o images/product-01.jpg "https://www.figma.com/api/mcp/asset/b35551a4-f5dd-4616-a166-614d10c11593"
curl -L -o images/product-02.jpg "https://www.figma.com/api/mcp/asset/b6a22d65-0510-46b2-b9e8-b3856e250516"
curl -L -o images/product-03.jpg "https://www.figma.com/api/mcp/asset/aed5c895-b9f0-4dd9-b92b-21d6ada187fb"
curl -L -o images/product-04.jpg "https://www.figma.com/api/mcp/asset/8eddb172-a3fc-4f47-85b7-8000457cdf1f"
curl -L -o images/product-05.jpg "https://www.figma.com/api/mcp/asset/54478c0b-9bc5-43b4-8615-7b62f8506329"

# Collection banners (2-grid)
curl -L -o images/collection-smart-chic.jpg "https://www.figma.com/api/mcp/asset/1a4128f6-d7f4-4900-b882-5c09ab0cadbc"
curl -L -o images/collection-ready-to-go.jpg "https://www.figma.com/api/mcp/asset/b17bc72d-07f9-44bd-be91-b7f4568694ac"

# Instagram images
curl -L -o images/ig-01.jpg "https://www.figma.com/api/mcp/asset/b46ac199-0ca0-4f8d-9a10-942934195623"
curl -L -o images/ig-02.jpg "https://www.figma.com/api/mcp/asset/835f0b9c-fc9b-4d8d-b0b7-e55017c2c77c"
curl -L -o images/ig-03.jpg "https://www.figma.com/api/mcp/asset/c7111428-6244-497a-9e94-86d6fcb390ea"
curl -L -o images/ig-04.jpg "https://www.figma.com/api/mcp/asset/71a4c850-fb24-44d5-a0af-a9ff1f0b9a27"
curl -L -o images/ig-05.jpg "https://www.figma.com/api/mcp/asset/dee88276-b200-47a5-b976-7f6bdd0147f2"

echo "=== 다운로드 완료! ==="
echo "총 $(ls images/ | wc -l)개 이미지 다운로드됨"
