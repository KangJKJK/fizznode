#!/bin/bash

# 텍스트 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Spheron Fizz 노드 설치 스크립트를 시작합니다...${NC}"

# 중요 안내사항 먼저 표시
echo -e "${RED}중요 안내사항: 설치 전 필수 준비사항${NC}"

lscpu | grep "CPU(s):"
free -h 
df -h 
echo -e "노드등록시 VPS의 CPU, RAM, 스토리지공간의 작성이 필요합니다. 미리 기억해두세요."
read -p "계속 진행하려면 엔터를 누르세요"

echo -e "1. 테스트넷 ETH 받기 (아래 사이트들 중 선택):"
echo -e "   - https://faucet.quicknode.com/arbitrum/sepolia"
echo -e "   - https://www.alchemy.com/faucets/arbitrum-sepolia"
echo -e "   - https://faucets.chain.link/arbitrum-sepolia"
echo -e "   - https://learnweb3.io/faucets/arbitrum_sepolia/"
read -p "계속 진행하려면 엔터를 누르세요"

echo -e "2. 토큰 및 브릿지:"
echo -e "   - Spheron 토큰 획득: https://faucet.spheron.network/"
echo -e "   - Sepolia-Arbitrum 브릿지: https://bridge.arbitrum.io/"
echo -e "   - Arbitrum-Spheron 브릿지: https://spheron-devnet-eth.bridge.caldera.xyz/"
read -p "계속 진행하려면 엔터를 누르세요"

echo -e "3. 노드 등록 과정:"
echo -e "   - https://fizz.spheron.network/ 방문"
echo -e "   - Register Fizz Node버튼을 클릭"
echo -e "   - WETH로 결제(테스트넷토큰) 선택 후 다운로드버튼 클릭"
read -p "계속 진행하려면 엔터를 누르세요"


echo -e "4. GitHub 설정:"
echo -e "   - https://github.com/ 접속"
echo -e "   - New repository 생성 (이름: Fizz)"
echo -e "   - Public 설정 및 Add a README file 선택"
echo -e "   - README 내용을 'Fizz'로 설정"
echo -e "   - Add File 선택 후 다운로드 받은 파일 업로드"

echo -e "모든 준비가 완료되었다면 계속 진행하려면 아무 키나 누르세요..."
read -n 1 -s

# 시스템 업데이트 및 기본 도구 설치
echo -e "${YELLOW}시스템 업데이트 및 기본 도구 설치중...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install curl build-essential git wget jq make gcc tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

# Docker 설치 확인 및 설치
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker 설치중...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
else
    echo -e "${GREEN}Docker가 이미 설치되어 있습니다.${NC}"
fi

# Docker Compose 설치
echo -e "${YELLOW}Docker Compose 설치중...${NC}"
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Docker 컨테이너 실행 (같은 디렉토리에서 실행)
echo -e "${YELLOW}Docker 컨테이너를 시작합니다...${NC}"
docker-compose up -d

# GitHub ID와 Fizz 버전 입력 받기
echo -e "${YELLOW}GitHub ID를 입력해주세요 (GitHub 프로필의 좌측 상단에 표시되는 사용자 아이디):${NC}"
read GITHUB_ID
echo -e "${GREEN}입력하신 GitHub ID: ${GITHUB_ID}${NC}"

echo -e "${YELLOW}다운로드 받으신 Fizz 버전을 입력해주세요 (예: 1.1.1):${NC}"
read FIZZ_VERSION
echo -e "${GREEN}입력하신 Fizz 버전: ${FIZZ_VERSION}${NC}"

# Fizz 설치 및 실행
echo -e "${YELLOW}Fizz 노드 설치를 시작합니다...${NC}"
wget "https://raw.githubusercontent.com/${GITHUB_ID}/Fizz/main/fizzup-v${FIZZ_VERSION}.sh"
chmod +x fizzup-v${FIZZ_VERSION}.sh
./fizzup-v${FIZZ_VERSION}.sh

echo -e "${GREEN}Fizz 노드설치가 완료되었습니다.${NC}"
echo -e "${GREEN}해당 명령어로 로그를 확인하세요: docker-compose -f ~/.spheron/fizz/docker-compose.yml logs -f${NC}"
echo -e "${GREEN}스크립트작성자: https://t.me/kjkresearch${NC}"
