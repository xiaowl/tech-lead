# tech-lead skillset

一个可被不同 agent 安装的 skill 集合。每个 skill 遵循 [Agent Skills](https://agentskills.io) 开放格式（目录 + `SKILL.md`），兼容 Claude Code、Codex CLI 等支持该格式的 agent。

## 包含的 skills

| Skill | 用途 |
|---|---|
| [tech-lead](skills/tech-lead/SKILL.md) | 为 agent 植入 tech lead 认知人格：反对过早收敛、机制寻因、竞争假设、结构化不确定性。适用于技术决策、根因分析、方案评审、调研判断等场景。 |

## 安装

```bash
# 自动检测已安装的 agent（claude / codex / opencode / goose）
./install.sh

# 指定 agent
./install.sh claude
./install.sh codex

# 或安装到任意 skills 目录
./install.sh /path/to/skills
```

各 agent 的 skills 目录：

- Claude Code: `~/.claude/skills/`
- Codex CLI: `~/.codex/skills/`
- OpenCode: `~/.config/opencode/skills/`
- Goose: `~/.config/goose/skills/`

## 目录结构

```
skills/
└── tech-lead/
    ├── SKILL.md                    # 人格底座（触发条件 + 核心机制）
    └── references/                 # 按需加载的深入材料
        ├── thinking-mechanisms.md  # 机制寻因与竞争假设操作方法
        ├── decision-playbook.md    # 不确定性下的决策格式
        └── failure-modes.md        # 反面自查清单
```

## 新增 skill

在 `skills/` 下新建目录，放入带 `name` / `description` frontmatter 的 `SKILL.md` 即可，`install.sh` 会自动发现并安装。
