# Git Hooks

git hook을 이용하여 프로세서를 구성하기 위해 만든 디렉토리

## 포함된 Hooks

### Pre-commit Hook
- **목적**: 커밋 전 코드 품질 검사
- **기능**: 
  - Staged 파일들의 품질 분석
  - AI agent를 통한 코드 리뷰
  - 품질 기준에 미달하는 경우 커밋 차단
- **스크립트**: `pre-commit`

### Commit Message Hook  
- **목적**: 커밋 메시지 자동 생성 및 향상
- **기능**:
  - 변경사항 분석을 통한 의미있는 커밋 메시지 생성
  - AI agent를 통한 커밋 메시지 향상
  - 일관된 커밋 메시지 형식 유지
- **스크립트**: `commit-msg`

## 설치 방법

### 자동 설치 (권장)
```bash
# Repository root에서 실행
./install-hooks.sh
```

### 수동 설치
```bash
# Hooks 복사
cp hooks/* .git/hooks/

# 실행 권한 부여  
chmod +x .git/hooks/*

# Python 스크립트 실행 권한 부여
chmod +x .git-hooks/*.py
```

## 제거 방법

```bash
# Repository root에서 실행
./uninstall-hooks.sh
```

## 📁 파일 구조

```
├── hooks/                          # Git hook 스크립트들
│   ├── pre-commit                  # Pre-commit hook
│   ├── commit-msg                  # Commit message hook  
│   └── README.md                   # 이 파일
├── .git-hooks/                     # Python 스크립트들
│   ├── pre_commit_check.py         # Pre-commit 품질 검사 로직
│   └── commit_msg_generator.py     # 커밋 메시지 생성 로직
├── install-hooks.sh                # 설치 스크립트
└── uninstall-hooks.sh              # 제거 스크립트
```

## 커스터마이징

### AI Agent 연동
Python 스크립트 파일들에서 `TODO` 주석이 있는 부분에 실제 AI agent 호출 로직을 구현하세요:

- **`.git-hooks/pre_commit_check.py`**: `run_quality_check()` 함수
- **`.git-hooks/commit_msg_generator.py`**: `generate_enhanced_message()` 함수

### 품질 검사 규칙 수정
`pre_commit_check.py`에서 검사할 파일 타입, 품질 기준 등을 수정할 수 있습니다.

### 커밋 메시지 형식 변경
`commit_msg_generator.py`에서 생성되는 커밋 메시지의 형식과 내용을 customization할 수 있습니다.

## 요구사항

- **Python 3.6+**: Python 스크립트 실행용
- **Git**: 기본 git 기능
- **Bash**: 설치/제거 스크립트 실행용

## 문제 해결

### Hook이 실행되지 않는 경우
1. 실행 권한 확인: `ls -la .git/hooks/`
2. Python 스크립트 권한 확인: `ls -la .git-hooks/`
3. Python 경로 확인: `which python3`

### 설치 스크립트 오류
1. Git repository 내부에서 실행하는지 확인
2. 필요한 권한이 있는지 확인
3. 이전 설치의 백업 파일 충돌 확인

### Python 스크립트 오류  
1. Python 3 설치 여부 확인
2. 스크립트 파일 존재 여부 확인
3. 파일 경로 및 권한 확인

## 사용 예시

```bash
# 1. Hooks 설치
./install-hooks.sh

# 2. 파일 수정 후 커밋 시도
git add .
git commit -m "feat: Add new feature"

# Pre-commit hook이 자동 실행되어 품질 검사 수행
# Commit-msg hook이 자동 실행되어 메시지 향상

# 3. 필요시 hooks 제거
./uninstall-hooks.sh
```

## 기여하기

1. Hook 스크립트 개선사항이 있다면 `hooks/` 디렉토리의 파일을 수정
2. Python 로직 개선사항이 있다면 `.git-hooks/` 디렉토리의 파일을 수정  
3. 변경사항을 commit하여 팀과 공유

