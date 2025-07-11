#!/bin/bash
#
# Development Environment Setup Script
# Run this script once after cloning the repository to set up your development environment
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR")"

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE}Spring Framework Petclinic Development Setup${NC}"
echo -e "${BLUE}=================================================${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Step 1: Check prerequisites
echo -e "${CYAN}Step 1: Checking prerequisites...${NC}"

# Check Java
if command -v java >/dev/null 2>&1; then
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo -e "   [OK] Java found: $JAVA_VERSION"
else
    echo -e "   [ERROR] Java not found. Please install Java 17 or later"
    exit 1
fi

# Check Maven
if command -v mvn >/dev/null 2>&1; then
    MVN_VERSION=$(mvn -version 2>&1 | head -n 1 | awk '{print $3}')
    echo -e "   [OK] Maven found: $MVN_VERSION"
else
    echo -e "   [ERROR] Maven not found. Please install Maven 3.8.4 or later"
    exit 1
fi

# Check Python
if command -v python3 >/dev/null 2>&1; then
    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
    echo -e "   [OK] Python found: $PYTHON_VERSION"
else
    echo -e "   [WARNING] Python 3 not found. Git hooks will not work properly"
fi

# Check Git
if command -v git >/dev/null 2>&1; then
    GIT_VERSION=$(git --version | awk '{print $3}')
    echo -e "   [OK] Git found: $GIT_VERSION"
else
    echo -e "   [ERROR] Git not found"
    exit 1
fi

echo ""

# Step 2: Install Git Hooks
echo -e "${CYAN}Step 2: Installing AI-powered Git Hooks...${NC}"

if [ -f "$REPO_ROOT/install-hooks.sh" ]; then
    cd "$REPO_ROOT"
    ./install-hooks.sh
    echo -e "   ${GREEN}[OK] Git hooks installation completed${NC}"
else
    echo -e "   ${RED}[ERROR] install-hooks.sh not found${NC}"
    exit 1
fi

echo ""

# Step 3: Verify Maven build
echo -e "${CYAN}Step 3: Verifying Maven build...${NC}"

cd "$REPO_ROOT"
if mvn clean compile >/dev/null 2>&1; then
    echo -e "   ${GREEN}[OK] Maven build successful${NC}"
else
    echo -e "   ${YELLOW}[WARNING] Maven build failed. You may need to resolve dependencies${NC}"
fi

echo ""

# Step 4: Setup IDE configuration (optional)
echo -e "${CYAN}Step 4: IDE Configuration (Optional)...${NC}"

# Create .vscode settings if not exists
if [ ! -d "$REPO_ROOT/.vscode" ]; then
    mkdir -p "$REPO_ROOT/.vscode"
    
    # Create settings.json for VS Code
    cat > "$REPO_ROOT/.vscode/settings.json" << 'EOF'
{
    "java.configuration.updateBuildConfiguration": "automatic",
    "java.compile.nullAnalysis.mode": "automatic",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": "explicit"
    },
    "files.exclude": {
        "**/target": true,
        "**/.git": true
    }
}
EOF
    echo -e "   ${GREEN}[OK] VS Code settings created${NC}"
else
    echo -e "   ${BLUE}[INFO] VS Code settings already exist${NC}"
fi

# Create .gitignore additions if needed
if ! grep -q ".vscode" "$REPO_ROOT/.gitignore" 2>/dev/null; then
    echo "" >> "$REPO_ROOT/.gitignore"
    echo "# IDE" >> "$REPO_ROOT/.gitignore"
    echo ".vscode/" >> "$REPO_ROOT/.gitignore"
    echo ".idea/" >> "$REPO_ROOT/.gitignore"
    echo "*.iml" >> "$REPO_ROOT/.gitignore"
    echo -e "   ${GREEN}[OK] Updated .gitignore for IDEs${NC}"
fi

echo ""

# Step 5: Setup complete
echo -e "${BLUE}=================================================${NC}"
echo -e "${GREEN}Development environment setup completed!${NC}"
echo -e "${BLUE}=================================================${NC}"
echo ""

echo -e "${BLUE}What was configured:${NC}"
echo -e "   * ${GREEN}Prerequisites verified${NC}"
echo -e "   * ${GREEN}AI-powered Git hooks installed${NC}"
echo -e "   * ${GREEN}Maven build verified${NC}"
echo -e "   * ${GREEN}IDE configuration created${NC}"
echo ""

echo -e "${BLUE}Next steps:${NC}"
echo -e "   * ${YELLOW}Run tests:${NC} mvn test"
echo -e "   * ${YELLOW}Start application:${NC} mvn jetty:run"
echo -e "   * ${YELLOW}Access application:${NC} http://localhost:8080/petclinic"
echo -e "   * ${YELLOW}Make a test commit:${NC} git add . && git commit -m \"test: Setup development environment\""
echo ""

echo -e "${BLUE}Git Hooks Features:${NC}"
echo -e "   * ${CYAN}Pre-commit:${NC} Automatically runs quality checks"
echo -e "   * ${CYAN}Commit-msg:${NC} Enhances commit messages with AI"
echo ""

echo -e "${BLUE}Useful commands:${NC}"
echo -e "   * ${YELLOW}./uninstall-hooks.sh${NC} - Remove git hooks"
echo -e "   * ${YELLOW}./install-hooks.sh${NC} - Reinstall git hooks"
echo -e "   * ${YELLOW}mvn clean package${NC} - Build application"
echo ""

echo -e "${GREEN}Happy coding!${NC}" 