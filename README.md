# CantaVue · 谱翎宣传官网

## 33 种语言官网 · 2026-09-17

官网已补齐与应用一致的 33 种语言，34 套 ARB 各 134 条（含中文兼容资源）。首页、隐私、条款及支持共 132 个独立文档，提供完整语言菜单、可刷新语言网址、搜索语言标记、阿拉伯文与希伯来文 RTL 布局。同步包含此前 9 月 14 日的政策更新。详细来源与维护方法见 `docs/MULTILINGUAL.md`。

70 项界面与路由测试通过，覆盖全部语言桌面及 320 px／200% 字号；132 个静态文档和字体覆盖检查通过。正式包构建成功。新增译文已作术语及含义核对，但尚无逐语母语者独立审校。下方带日期记录保留当时状态。

## 发布缺口补齐 · 2026-09-14

本机教学、课程通知、主动 HTTPS／WebDAV／配置后网盘传输及凭据生命周期已补入三语政策、条款和支持全文，并与主 App 离线政策一致。普通浏览器已核对公开站点可读，但仍显示 9 月 7 日旧版；本轮仅完成本地构建，尚未部署新文案。

四套 ARB 各 134 条消息，6 份 Noto 字体经字形覆盖核对和裁切后合计 1,610,708 字节。下载工具校验完整响应、重试临时连接错误，在主项目忽略目录缓存已完成下载；缓存不进入网站产物。新增 cupertino_icons 1.0.9 为可达 Flutter 自适应控件补字体，MIT 许可，不含平台插件、权限或网络请求。正式包内该字体为 1,472 字节，构建不再有字体缺失提示。

严格分析无问题；6 项测试通过，包括三语 320 px／200% 字号。旧 FAQ 测试仍断言没有公开下载，现验证已有 TestFlight 邀请文案可展开、收起。最终 Flutter Web 构建成功，编译 14.5 秒；保留 Flutter 官方 PWA 参数弃用提示。下方旧记录按日期保留。

独立 Flutter Web 官网，固定 Flutter 3.41.5 / Dart 3.11.3。首页提供与应用一致的 33 种语言，介绍当前开发版已接入的读谱、批注、谱库与练习方向；准确标注开发验证、下载和定价状态。不会替换主应用或更改 185 条需求的验收状态。

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

`tool/flutter.dart` 是主项目的独立配置包装器副本，输出只写入本官网目录，不改 SDK 或全局配置。`tool/build.dart` 生成 33 语静态搜索文档、站点地图和 Flutter release 后，把公开产物复制到 `dist/`，供 Sites 静态托管。构建会关闭 CDN 渲染资源及 PWA service worker，字体随包提供。原图位于 `assets/hero.png`，不包含真实私人乐谱；说明见 `docs/ASSETS.md`。

正式域名确定并授权后，把可信 HTTPS origin 传给 `dart run tool/build.dart https://实际域名`，同步重建 canonical、hreflang 和 sitemap；DNS 与公开访问控制需另行处理，不能把 Sites 私有预览当成公开官网已经上线。

## 文案、搜索与可访问性

- 可见产品文案统一位于 `lib/l10n/*.arb`；品牌和语言自称为例外。简繁资源分别保存。
- `/` 及 32 个语言网址（如 `/en`、`/ar`）有各自的静态 HTML、标题、说明、canonical 与 hreflang；JavaScript 不可用时仍能阅读完整产品与 FAQ 内容。
- Flutter 语言切换会同步更新页面语言、地址与元数据，刷新后保持语言。导航、语言菜单和 FAQ 使用 Flutter Material 组件的键盘／语义支持。
- 窄屏和大字号采用折叠导航；尊重减少动画设置。没有注册、候补名单、自动邮件发送或支付；Sites 提供基础访问统计，已在隐私政策中说明。
- iOS TestFlight 邀请入口已提供，正式版定价尚未确定。反馈邮箱为用户指定的 info@cantavue.com。

## 素材与依赖

沿用已选 A1 品牌图；钢琴与平板主视觉由 imagegen 独立生成，是明确标注的场景概念图，不是产品截图。没有打包主应用数据库、用户乐谱、录音、账号信息或私人诊断。

运行时使用 Flutter SDK、flutter_localizations、cupertino_icons 1.0.9 和 SDK 所需 intl 0.20.2；开发检查使用 flutter_test/flutter_lints。与主应用依赖隔离，无新增平台权限。Flutter 和 intl 采用 BSD 系列许可。

Noto Sans SC／TC 400、600、700 各一份，均为 Google Fonts 按公开 ARB 文案生成的 TTF 字符子集，合计 **1,610,708 字节**。使用 SIL Open Font License 1.1，完整许可证随资产打包。它们让官网中文和英文不依赖外部字体请求，不修改主应用字体。官方来源为 `docs/FONTS.json` 与 `assets/fonts/OFL-*.txt`；`tool/fetch_fonts.py` 可在公开文案改变后刷新。字体源与许可：[Noto Sans SC](https://github.com/google/fonts/tree/main/ofl/notosanssc)、[Noto Sans TC](https://github.com/google/fonts/tree/main/ofl/notosanstc)。

## 验证

结果记录在主项目 `docs/STATUS.md` 的“33 语官网”条目。网站有独立 70 项测试，覆盖语言网址、桌面导航、FAQ 及全部语言 320 px／200% 字号和窄屏菜单。浏览器抽查页面实际渲染；未进行全部语言实体设备验收，不把官网构建当作应用功能验收。

## 2026-09-07 场景图片补充

“为音乐而作”增加小提琴教学、乐团演出与脚踏翻页三张原创场景图。桌面先并排教学与乐团，再用宽行展示脚踏、谱架和双手演奏的关系；窄屏按相同阅读顺序纵向排布。原有钢琴主视觉与准备流程保留。新增 14 条文案及图片替代描述，4 个 ARB 各 78 条，静态三语文档同步包含图片、替代文本与设备验证边界。

三张 WebP 各 1536×1024，保留完整 3:2 构图，质量 86，合计 **442,966 字节**。未裁切、添加品牌或模拟操作动画。来源和限制见 `docs/SCENE_PROVENANCE.md`；运行时文件大小与 SHA-256 见 `docs/SCENE_ASSETS.json`。场景是合成使用示意，不是实际用户案例、课堂管理、乐团同步或硬件认证证据。脚踏图表现一个脚踩开关的静止瞬间，不能作为已完成翻页的证明；正文明确兼容键盘式脚踏和真机仍待验证。

本轮仍未改变主应用、185 条需求记录、访问受众或正式域名。

## 隐私、条款与支持 · 2026-09-07

正式 origin 现为 `https://www.cantavue.com`，已通过 Sites 查询核实绑定、HTTPS 和现有公开受众。首页新增三语政策、条款、支持及邮件入口。`privacy.html`、`terms.html`、`support.html` 为简体版本，`-zh-Hant.html` 和 `-en.html` 为对应翻译；九个独立文档无需 JavaScript 即可阅读。所有可见文案保持在 ARB，目录和返回入口支持直接定位。数据流核对与边界见 `docs/PRIVACY_SCOPE.md`。

新增文案后先运行 `python3 tool/fetch_fonts.py`，再使用安装了 `fonttools==4.60.1` 的开发 Python 执行 `tool/subset_fonts.py`，避免 Google Fonts 对长字符请求回退到完整 CJK 字体。fonttools 为 MIT 授权、只用于开发期字体裁切，不进入运行时。

### 脚踏位置修正 · 2026-09-07

按用户反馈，脚踏图改用 `pedal-page-turn-aligned-v2.png` 的 WebP 导出：双键的排列转到演奏者左右方向的地面透视，并靠近右脚的自然落点，另一按键保持可见。原始图和未采用的首轮移动结果保留在设计目录。只替换这张图片，不改布局、功能文案或硬件支持范围。编辑提示词与检查记录见 `docs/PEDAL_ALIGNMENT.md`。
