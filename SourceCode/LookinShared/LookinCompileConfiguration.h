//
//  LookinCompileConfiguration.h
//  LookinServer
//
//  Created by Li Kai on 2019/10/29.
//  https://lookin.work
//

/// 每一个 Lookin 的 .h 和 .m 文件都在 “#ifdef CAN_COMPILE_LOOKIN_SERVER” 的包裹之内，因此下面这句 “ #if (defined(DEBUG)) ” 会使得 Lookin 仅会在 Debug 模式下被编译进你的项目，而无需担心 release 模式下别人使用 Lookin 连接你的 app
/// 假如你要同时在 “DEBUG” 和一个叫 “DailyBuild” 的模式下编译 Lookin，则把下面这句 “ #if (defined(DEBUG)) ” 改成 “ #if (defined(DEBUG)) || (defined(DailyBuild)) ” 即可

/// All codes of Lookin is embraced by “#ifdef CAN_COMPILE_LOOKIN_SERVER”. Therefore, " #if (defined(DEBUG)) " will make LookinServer only to be compiled in Debug configuration.
/// If you want to use Lookin in both "DEBUG" and another configuration(e.g. "DailyBuild"), replace “ #if (defined(DEBUG)) ” below instead of “ #if (defined(DEBUG)) || (defined(DailyBuild)) ”

//#if (defined(DEBU))
#define CAN_COMPILE_LOOKIN_SERVER
//#endif
