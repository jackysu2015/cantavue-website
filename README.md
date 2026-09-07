# CantaVue · 谱翎宣传官网

独立 Flutter Web 官网，固定 Flutter 3.41.5 / Dart 3.11.3。首页提供简体中文、繁体中文和英文，介绍当前开发版已接入的读谱、批注、谱库与练习方向；准确标注开发验证、下载和定价状态。不会替换主应用或更改 185 条需求的验收状态。

## 开发与构建

在本目录执行：

```sh
dart run tool/flutter.dart pub get --enforce-lockfile
dart run tool/flutter.dart gen-l10n
dart run tool/build_document.dart
dart run tool/flutter.dart run -d web-server --web-hostname 127.0.0.1 --web-port 4177
dart run tool/flutter.dart analyze --fatal-infos
dart run tool/flutter.dart test
dart run tool/build.dart
```

`tool/flutter.dart` 是主项目的独立配置包装器副本，输出只写入本官网目录，不改 SDK 或全局配置。`tool/build.dart` 生成三语静态搜索文档、站点地图和 Flutter release 后，把公开产物复制到 `dist/`，供 Sites 静态托管。构建会关闭 CDN 渲染资源及 PWA service worker，字体随包提供。原图位于 `assets/hero.png`，不包含真实私人乐谱；说明见 `docs/ASSETS.md`。

正式域名确定并授权后，把可信 HTTPS origin 传给 `dart run tool/build.dart https://实际域名`，同步重建 canonical、hreflang 和 sitemap；DNS 与公开访问控制需另行处理，不能把 Sites 私有预览当成公开官网已经上线。

## 文案、搜索与可访问性

- 可见产品文案统一位于 `lib/l10n/*.arb`；品牌和语言自称为例外。简繁资源分别保存。
- `/`、`/zh-Hant.html`、`/en.html` 有各自的静态 HTML、标题、说明、canonical 与 hreflang；JavaScript 不可用时仍能阅读完整产品与 FAQ 内容。
- Flutter 语言切换会同步更新页面语言、地址与元数据，刷新后保持语言。导航、语言菜单和 FAQ 使用 Flutter Material 组件的键盘／语义支持。
- 窄屏和大字号采用折叠导航；尊重减少动画设置。没有注册、候补名单、自动邮件发送或支付；Sites 提供基础访问统计，已在隐私政策中说明。
- 公开公测 URL、下载地址及定价未确定，不伪造对应入口。反馈邮箱为用户指定的 info@cantavue.com。

## 素材与依赖

沿用已选 A1 品牌图；钢琴与平板主视觉由 imagegen 独立生成，是明确标注的场景概念图，不是产品截图。没有打包主应用数据库、用户乐谱、录音、账号信息或私人诊断。

运行时仅使用 Flutter SDK、flutter_localizations 和 SDK 所需 intl 0.20.2；开发检查使用 flutter_test/flutter_lints。与主应用依赖隔离，无新增平台权限。Flutter 和 intl 采用 BSD 系列许可。

Noto Sans SC／TC 400、600、700 各一份，均为 Google Fonts 按公开 ARB 文案生成的 TTF 字符子集，合计 **1,503,120 字节**。使用 SIL Open Font License 1.1，完整许可证随资产打包。它们让官网中文和英文不依赖外部字体请求，不修改主应用字体。官方来源为 `docs/FONTS.json` 与 `assets/fonts/OFL-*.txt`；`tool/fetch_fonts.py` 可在公开文案改变后刷新。字体源与许可：[Noto Sans SC](https://github.com/google/fonts/tree/main/ofl/notosanssc)、[Noto Sans TC](https://github.com/google/fonts/tree/main/ofl/notosanstc)。

## 验证

结果记录在主项目 `docs/STATUS.md` 的“宣传官网”条目。网站有独立 5 项测试，覆盖桌面导航返回、切换英文及 FAQ 展开、三语 320 px／200% 字号和窄屏菜单。没有本轮浏览器自动操作或实体设备视觉验收；不把官网构建当作应用功能验收。

## 2026-09-07 场景图片补充

“为音乐而作”增加小提琴教学、乐团演出与脚踏翻页三张原创场景图。桌面先并排教学与乐团，再用宽行展示脚踏、谱架和双手演奏的关系；窄屏按相同阅读顺序纵向排布。原有钢琴主视觉与准备流程保留。新增 14 条文案及图片替代描述，4 个 ARB 各 78 条，静态三语文档同步包含图片、替代文本与设备验证边界。

三张 WebP 各 1536×1024，保留完整 3:2 构图，质量 86，合计 **442,966 字节**。未裁切、添加品牌或模拟操作动画。来源和限制见 `docs/SCENE_PROVENANCE.md`；运行时文件大小与 SHA-256 见 `docs/SCENE_ASSETS.json`。场景是合成使用示意，不是实际用户案例、课堂管理、乐团同步或硬件认证证据。脚踏图表现一个脚踩开关的静止瞬间，不能作为已完成翻页的证明；正文明确兼容键盘式脚踏和真机仍待验证。

本轮仍未改变主应用、185 条需求记录、访问受众或正式域名。

## 隐私、条款与支持 · 2026-09-07

正式 origin 现为 `https://www.cantavue.com`，已通过 Sites 查询核实绑定、HTTPS 和现有公开受众。首页新增三语政策、条款、支持及邮件入口。`privacy.html`、`terms.html`、`support.html` 为简体版本，`-zh-Hant.html` 和 `-en.html` 为对应翻译；九个独立文档无需 JavaScript 即可阅读。所有可见文案保持在 ARB，目录和返回入口支持直接定位。数据流核对与边界见 `docs/PRIVACY_SCOPE.md`。

新增文案后先运行 `python3 tool/fetch_fonts.py`，再使用安装了 `fonttools==4.60.1` 的开发 Python 执行 `tool/subset_fonts.py`，避免 Google Fonts 对长字符请求回退到完整 CJK 字体。fonttools 为 MIT 授权、只用于开发期字体裁切，不进入运行时。

### 脚踏位置修正 · 2026-09-07

按用户反馈，脚踏图改用 `pedal-page-turn-aligned-v2.png` 的 WebP 导出：双键的排列转到演奏者左右方向的地面透视，并靠近右脚的自然落点，另一按键保持可见。原始图和未采用的首轮移动结果保留在设计目录。只替换这张图片，不改布局、功能文案或硬件支持范围。编辑提示词与检查记录见 `docs/PEDAL_ALIGNMENT.md`。
