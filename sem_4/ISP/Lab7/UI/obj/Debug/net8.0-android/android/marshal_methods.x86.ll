; ModuleID = 'marshal_methods.x86.ll'
source_filename = "marshal_methods.x86.ll"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i686-unknown-linux-android21"

%struct.MarshalMethodName = type {
	i64, ; uint64_t id
	ptr ; char* name
}

%struct.MarshalMethodsManagedClass = type {
	i32, ; uint32_t token
	ptr ; MonoClass klass
}

@assembly_image_cache = dso_local local_unnamed_addr global [335 x ptr] zeroinitializer, align 4

; Each entry maps hash of an assembly name to an index into the `assembly_image_cache` array
@assembly_image_cache_hashes = dso_local local_unnamed_addr constant [664 x i32] [
	i32 2616222, ; 0: System.Net.NetworkInformation.dll => 0x27eb9e => 68
	i32 10166715, ; 1: System.Net.NameResolution.dll => 0x9b21bb => 67
	i32 15721112, ; 2: System.Runtime.Intrinsics.dll => 0xefe298 => 108
	i32 26230656, ; 3: Microsoft.Extensions.DependencyModel => 0x1903f80 => 192
	i32 32687329, ; 4: Xamarin.AndroidX.Lifecycle.Runtime => 0x1f2c4e1 => 252
	i32 34715100, ; 5: Xamarin.Google.Guava.ListenableFuture.dll => 0x211b5dc => 286
	i32 34839235, ; 6: System.IO.FileSystem.DriveInfo => 0x2139ac3 => 48
	i32 38948123, ; 7: ar\Microsoft.Maui.Controls.resources.dll => 0x2524d1b => 294
	i32 39485524, ; 8: System.Net.WebSockets.dll => 0x25a8054 => 80
	i32 42244203, ; 9: he\Microsoft.Maui.Controls.resources.dll => 0x284986b => 303
	i32 42639949, ; 10: System.Threading.Thread => 0x28aa24d => 145
	i32 66541672, ; 11: System.Diagnostics.StackTrace => 0x3f75868 => 30
	i32 67008169, ; 12: zh-Hant\Microsoft.Maui.Controls.resources => 0x3fe76a9 => 327
	i32 68219467, ; 13: System.Security.Cryptography.Primitives => 0x410f24b => 124
	i32 72070932, ; 14: Microsoft.Maui.Graphics.dll => 0x44bb714 => 206
	i32 82292897, ; 15: System.Runtime.CompilerServices.VisualC.dll => 0x4e7b0a1 => 102
	i32 83839681, ; 16: ms\Microsoft.Maui.Controls.resources.dll => 0x4ff4ac1 => 311
	i32 101534019, ; 17: Xamarin.AndroidX.SlidingPaneLayout => 0x60d4943 => 270
	i32 117431740, ; 18: System.Runtime.InteropServices => 0x6ffddbc => 107
	i32 120558881, ; 19: Xamarin.AndroidX.SlidingPaneLayout.dll => 0x72f9521 => 270
	i32 122350210, ; 20: System.Threading.Channels.dll => 0x74aea82 => 139
	i32 134690465, ; 21: Xamarin.Kotlin.StdLib.Jdk7.dll => 0x80736a1 => 290
	i32 136584136, ; 22: zh-Hans\Microsoft.Maui.Controls.resources.dll => 0x8241bc8 => 326
	i32 140062828, ; 23: sk\Microsoft.Maui.Controls.resources.dll => 0x859306c => 319
	i32 142721839, ; 24: System.Net.WebHeaderCollection => 0x881c32f => 77
	i32 149972175, ; 25: System.Security.Cryptography.Primitives.dll => 0x8f064cf => 124
	i32 159306688, ; 26: System.ComponentModel.Annotations => 0x97ed3c0 => 13
	i32 165246403, ; 27: Xamarin.AndroidX.Collection.dll => 0x9d975c3 => 226
	i32 176265551, ; 28: System.ServiceProcess => 0xa81994f => 132
	i32 182336117, ; 29: Xamarin.AndroidX.SwipeRefreshLayout.dll => 0xade3a75 => 272
	i32 184328833, ; 30: System.ValueTuple.dll => 0xafca281 => 151
	i32 205061960, ; 31: System.ComponentModel => 0xc38ff48 => 18
	i32 209399409, ; 32: Xamarin.AndroidX.Browser.dll => 0xc7b2e71 => 224
	i32 220171995, ; 33: System.Diagnostics.Debug => 0xd1f8edb => 26
	i32 230216969, ; 34: Xamarin.AndroidX.Legacy.Support.Core.Utils.dll => 0xdb8d509 => 246
	i32 230752869, ; 35: Microsoft.CSharp.dll => 0xdc10265 => 1
	i32 231409092, ; 36: System.Linq.Parallel => 0xdcb05c4 => 59
	i32 231814094, ; 37: System.Globalization => 0xdd133ce => 42
	i32 246610117, ; 38: System.Reflection.Emit.Lightweight => 0xeb2f8c5 => 91
	i32 261689757, ; 39: Xamarin.AndroidX.ConstraintLayout.dll => 0xf99119d => 229
	i32 276479776, ; 40: System.Threading.Timer.dll => 0x107abf20 => 147
	i32 278686392, ; 41: Xamarin.AndroidX.Lifecycle.LiveData.dll => 0x109c6ab8 => 248
	i32 280482487, ; 42: Xamarin.AndroidX.Interpolator => 0x10b7d2b7 => 245
	i32 291076382, ; 43: System.IO.Pipes.AccessControl.dll => 0x1159791e => 54
	i32 298918909, ; 44: System.Net.Ping.dll => 0x11d123fd => 69
	i32 317674968, ; 45: vi\Microsoft.Maui.Controls.resources => 0x12ef55d8 => 324
	i32 318968648, ; 46: Xamarin.AndroidX.Activity.dll => 0x13031348 => 215
	i32 321597661, ; 47: System.Numerics => 0x132b30dd => 83
	i32 321963286, ; 48: fr\Microsoft.Maui.Controls.resources.dll => 0x1330c516 => 302
	i32 342366114, ; 49: Xamarin.AndroidX.Lifecycle.Common => 0x146817a2 => 247
	i32 347068432, ; 50: SQLitePCLRaw.lib.e_sqlite3.android.dll => 0x14afd810 => 209
	i32 360082299, ; 51: System.ServiceModel.Web => 0x15766b7b => 131
	i32 367780167, ; 52: System.IO.Pipes => 0x15ebe147 => 55
	i32 374914964, ; 53: System.Transactions.Local => 0x1658bf94 => 149
	i32 375677976, ; 54: System.Net.ServicePoint.dll => 0x16646418 => 74
	i32 379916513, ; 55: System.Threading.Thread.dll => 0x16a510e1 => 145
	i32 385762202, ; 56: System.Memory.dll => 0x16fe439a => 62
	i32 392610295, ; 57: System.Threading.ThreadPool.dll => 0x1766c1f7 => 146
	i32 395744057, ; 58: _Microsoft.Android.Resource.Designer => 0x17969339 => 331
	i32 403441872, ; 59: WindowsBase => 0x180c08d0 => 165
	i32 403493213, ; 60: MediatR.Contracts => 0x180cd15d => 178
	i32 409257351, ; 61: tr\Microsoft.Maui.Controls.resources.dll => 0x1864c587 => 322
	i32 441335492, ; 62: Xamarin.AndroidX.ConstraintLayout.Core => 0x1a4e3ec4 => 230
	i32 442565967, ; 63: System.Collections => 0x1a61054f => 12
	i32 450948140, ; 64: Xamarin.AndroidX.Fragment.dll => 0x1ae0ec2c => 243
	i32 451504562, ; 65: System.Security.Cryptography.X509Certificates => 0x1ae969b2 => 125
	i32 456227837, ; 66: System.Web.HttpUtility.dll => 0x1b317bfd => 152
	i32 457806524, ; 67: Application => 0x1b4992bc => 328
	i32 459347974, ; 68: System.Runtime.Serialization.Primitives.dll => 0x1b611806 => 113
	i32 465846621, ; 69: mscorlib => 0x1bc4415d => 166
	i32 469710990, ; 70: System.dll => 0x1bff388e => 164
	i32 476646585, ; 71: Xamarin.AndroidX.Interpolator.dll => 0x1c690cb9 => 245
	i32 486930444, ; 72: Xamarin.AndroidX.LocalBroadcastManager.dll => 0x1d05f80c => 258
	i32 489220957, ; 73: es\Microsoft.Maui.Controls.resources.dll => 0x1d28eb5d => 300
	i32 498788369, ; 74: System.ObjectModel => 0x1dbae811 => 84
	i32 513247710, ; 75: Microsoft.Extensions.Primitives.dll => 0x1e9789de => 200
	i32 526420162, ; 76: System.Transactions.dll => 0x1f6088c2 => 150
	i32 527452488, ; 77: Xamarin.Kotlin.StdLib.Jdk7 => 0x1f704948 => 290
	i32 530272170, ; 78: System.Linq.Queryable => 0x1f9b4faa => 60
	i32 538707440, ; 79: th\Microsoft.Maui.Controls.resources.dll => 0x201c05f0 => 321
	i32 539058512, ; 80: Microsoft.Extensions.Logging => 0x20216150 => 196
	i32 540030774, ; 81: System.IO.FileSystem.dll => 0x20303736 => 51
	i32 545304856, ; 82: System.Runtime.Extensions => 0x2080b118 => 103
	i32 546455878, ; 83: System.Runtime.Serialization.Xml => 0x20924146 => 114
	i32 549171840, ; 84: System.Globalization.Calendars => 0x20bbb280 => 40
	i32 557405415, ; 85: Jsr305Binding => 0x213954e7 => 283
	i32 569601784, ; 86: Xamarin.AndroidX.Window.Extensions.Core.Core => 0x21f36ef8 => 281
	i32 577335427, ; 87: System.Security.Cryptography.Cng => 0x22697083 => 120
	i32 597488923, ; 88: CommunityToolkit.Maui => 0x239cf51b => 173
	i32 601371474, ; 89: System.IO.IsolatedStorage.dll => 0x23d83352 => 52
	i32 605376203, ; 90: System.IO.Compression.FileSystem => 0x24154ecb => 44
	i32 613668793, ; 91: System.Security.Cryptography.Algorithms => 0x2493d7b9 => 119
	i32 627609679, ; 92: Xamarin.AndroidX.CustomView => 0x2568904f => 235
	i32 627931235, ; 93: nl\Microsoft.Maui.Controls.resources => 0x256d7863 => 313
	i32 639843206, ; 94: Xamarin.AndroidX.Emoji2.ViewsHelper.dll => 0x26233b86 => 241
	i32 643868501, ; 95: System.Net => 0x2660a755 => 81
	i32 654720004, ; 96: UI.dll => 0x27063c04 => 0
	i32 662205335, ; 97: System.Text.Encodings.Web.dll => 0x27787397 => 136
	i32 663517072, ; 98: Xamarin.AndroidX.VersionedParcelable => 0x278c7790 => 277
	i32 666292255, ; 99: Xamarin.AndroidX.Arch.Core.Common.dll => 0x27b6d01f => 222
	i32 672442732, ; 100: System.Collections.Concurrent => 0x2814a96c => 8
	i32 683518922, ; 101: System.Net.Security => 0x28bdabca => 73
	i32 690569205, ; 102: System.Xml.Linq.dll => 0x29293ff5 => 155
	i32 691348768, ; 103: Xamarin.KotlinX.Coroutines.Android.dll => 0x29352520 => 292
	i32 693804605, ; 104: System.Windows => 0x295a9e3d => 154
	i32 699345723, ; 105: System.Reflection.Emit => 0x29af2b3b => 92
	i32 700284507, ; 106: Xamarin.Jetbrains.Annotations => 0x29bd7e5b => 287
	i32 700358131, ; 107: System.IO.Compression.ZipFile => 0x29be9df3 => 45
	i32 720511267, ; 108: Xamarin.Kotlin.StdLib.Jdk8 => 0x2af22123 => 291
	i32 722857257, ; 109: System.Runtime.Loader.dll => 0x2b15ed29 => 109
	i32 735137430, ; 110: System.Security.SecureString.dll => 0x2bd14e96 => 129
	i32 748832960, ; 111: SQLitePCLRaw.batteries_v2 => 0x2ca248c0 => 207
	i32 752232764, ; 112: System.Diagnostics.Contracts.dll => 0x2cd6293c => 25
	i32 755313932, ; 113: Xamarin.Android.Glide.Annotations.dll => 0x2d052d0c => 212
	i32 759454413, ; 114: System.Net.Requests => 0x2d445acd => 72
	i32 762598435, ; 115: System.IO.Pipes.dll => 0x2d745423 => 55
	i32 775507847, ; 116: System.IO.Compression => 0x2e394f87 => 46
	i32 777317022, ; 117: sk\Microsoft.Maui.Controls.resources => 0x2e54ea9e => 319
	i32 789151979, ; 118: Microsoft.Extensions.Options => 0x2f0980eb => 199
	i32 790371945, ; 119: Xamarin.AndroidX.CustomView.PoolingContainer.dll => 0x2f1c1e69 => 236
	i32 804715423, ; 120: System.Data.Common => 0x2ff6fb9f => 22
	i32 807930345, ; 121: Xamarin.AndroidX.Lifecycle.LiveData.Core.Ktx.dll => 0x302809e9 => 250
	i32 823281589, ; 122: System.Private.Uri.dll => 0x311247b5 => 86
	i32 830298997, ; 123: System.IO.Compression.Brotli => 0x317d5b75 => 43
	i32 832635846, ; 124: System.Xml.XPath.dll => 0x31a103c6 => 160
	i32 834051424, ; 125: System.Net.Quic => 0x31b69d60 => 71
	i32 843511501, ; 126: Xamarin.AndroidX.Print => 0x3246f6cd => 263
	i32 869139383, ; 127: hi\Microsoft.Maui.Controls.resources.dll => 0x33ce03b7 => 304
	i32 873119928, ; 128: Microsoft.VisualBasic => 0x340ac0b8 => 3
	i32 877678880, ; 129: System.Globalization.dll => 0x34505120 => 42
	i32 878954865, ; 130: System.Net.Http.Json => 0x3463c971 => 63
	i32 880668424, ; 131: ru\Microsoft.Maui.Controls.resources.dll => 0x347def08 => 318
	i32 904024072, ; 132: System.ComponentModel.Primitives.dll => 0x35e25008 => 16
	i32 911108515, ; 133: System.IO.MemoryMappedFiles.dll => 0x364e69a3 => 53
	i32 918734561, ; 134: pt-BR\Microsoft.Maui.Controls.resources.dll => 0x36c2c6e1 => 315
	i32 928116545, ; 135: Xamarin.Google.Guava.ListenableFuture => 0x3751ef41 => 286
	i32 952186615, ; 136: System.Runtime.InteropServices.JavaScript.dll => 0x38c136f7 => 105
	i32 956575887, ; 137: Xamarin.Kotlin.StdLib.Jdk8.dll => 0x3904308f => 291
	i32 961460050, ; 138: it\Microsoft.Maui.Controls.resources.dll => 0x394eb752 => 308
	i32 966729478, ; 139: Xamarin.Google.Crypto.Tink.Android => 0x399f1f06 => 284
	i32 967690846, ; 140: Xamarin.AndroidX.Lifecycle.Common.dll => 0x39adca5e => 247
	i32 975236339, ; 141: System.Diagnostics.Tracing => 0x3a20ecf3 => 34
	i32 975874589, ; 142: System.Xml.XDocument => 0x3a2aaa1d => 158
	i32 986514023, ; 143: System.Private.DataContractSerialization.dll => 0x3acd0267 => 85
	i32 987214855, ; 144: System.Diagnostics.Tools => 0x3ad7b407 => 32
	i32 990727110, ; 145: ro\Microsoft.Maui.Controls.resources.dll => 0x3b0d4bc6 => 317
	i32 992768348, ; 146: System.Collections.dll => 0x3b2c715c => 12
	i32 994442037, ; 147: System.IO.FileSystem => 0x3b45fb35 => 51
	i32 999186168, ; 148: Microsoft.Extensions.FileSystemGlobbing.dll => 0x3b8e5ef8 => 195
	i32 1001831731, ; 149: System.IO.UnmanagedMemoryStream.dll => 0x3bb6bd33 => 56
	i32 1012816738, ; 150: Xamarin.AndroidX.SavedState.dll => 0x3c5e5b62 => 267
	i32 1019214401, ; 151: System.Drawing => 0x3cbffa41 => 36
	i32 1028951442, ; 152: Microsoft.Extensions.DependencyInjection.Abstractions => 0x3d548d92 => 191
	i32 1031528504, ; 153: Xamarin.Google.ErrorProne.Annotations.dll => 0x3d7be038 => 285
	i32 1035644815, ; 154: Xamarin.AndroidX.AppCompat => 0x3dbaaf8f => 220
	i32 1036536393, ; 155: System.Drawing.Primitives.dll => 0x3dc84a49 => 35
	i32 1043950537, ; 156: de\Microsoft.Maui.Controls.resources.dll => 0x3e396bc9 => 298
	i32 1044663988, ; 157: System.Linq.Expressions.dll => 0x3e444eb4 => 58
	i32 1046434417, ; 158: Domain.dll => 0x3e5f5271 => 329
	i32 1052210849, ; 159: Xamarin.AndroidX.Lifecycle.ViewModel.dll => 0x3eb776a1 => 254
	i32 1067306892, ; 160: GoogleGson => 0x3f9dcf8c => 176
	i32 1082857460, ; 161: System.ComponentModel.TypeConverter => 0x408b17f4 => 17
	i32 1084122840, ; 162: Xamarin.Kotlin.StdLib => 0x409e66d8 => 288
	i32 1098259244, ; 163: System => 0x41761b2c => 164
	i32 1106973742, ; 164: Microsoft.Extensions.Configuration.FileExtensions.dll => 0x41fb142e => 188
	i32 1108272742, ; 165: sv\Microsoft.Maui.Controls.resources.dll => 0x420ee666 => 320
	i32 1117529484, ; 166: pl\Microsoft.Maui.Controls.resources.dll => 0x429c258c => 314
	i32 1118262833, ; 167: ko\Microsoft.Maui.Controls.resources => 0x42a75631 => 310
	i32 1121599056, ; 168: Xamarin.AndroidX.Lifecycle.Runtime.Ktx.dll => 0x42da3e50 => 253
	i32 1127624469, ; 169: Microsoft.Extensions.Logging.Debug => 0x43362f15 => 198
	i32 1149092582, ; 170: Xamarin.AndroidX.Window => 0x447dc2e6 => 280
	i32 1157931901, ; 171: Microsoft.EntityFrameworkCore.Abstractions => 0x4504a37d => 181
	i32 1168523401, ; 172: pt\Microsoft.Maui.Controls.resources => 0x45a64089 => 316
	i32 1170634674, ; 173: System.Web.dll => 0x45c677b2 => 153
	i32 1173126369, ; 174: Microsoft.Extensions.FileProviders.Abstractions.dll => 0x45ec7ce1 => 193
	i32 1175144683, ; 175: Xamarin.AndroidX.VectorDrawable.Animated => 0x460b48eb => 276
	i32 1178241025, ; 176: Xamarin.AndroidX.Navigation.Runtime.dll => 0x463a8801 => 261
	i32 1202000627, ; 177: Microsoft.EntityFrameworkCore.Abstractions.dll => 0x47a512f3 => 181
	i32 1204270330, ; 178: Xamarin.AndroidX.Arch.Core.Common => 0x47c7b4fa => 222
	i32 1204575371, ; 179: Microsoft.Extensions.Caching.Memory.dll => 0x47cc5c8b => 185
	i32 1208641965, ; 180: System.Diagnostics.Process => 0x480a69ad => 29
	i32 1214827643, ; 181: CommunityToolkit.Mvvm => 0x4868cc7b => 175
	i32 1219128291, ; 182: System.IO.IsolatedStorage => 0x48aa6be3 => 52
	i32 1243150071, ; 183: Xamarin.AndroidX.Window.Extensions.Core.Core.dll => 0x4a18f6f7 => 281
	i32 1253011324, ; 184: Microsoft.Win32.Registry => 0x4aaf6f7c => 5
	i32 1260983243, ; 185: cs\Microsoft.Maui.Controls.resources => 0x4b2913cb => 296
	i32 1264511973, ; 186: Xamarin.AndroidX.Startup.StartupRuntime.dll => 0x4b5eebe5 => 271
	i32 1267360935, ; 187: Xamarin.AndroidX.VectorDrawable => 0x4b8a64a7 => 275
	i32 1273260888, ; 188: Xamarin.AndroidX.Collection.Ktx => 0x4be46b58 => 227
	i32 1275534314, ; 189: Xamarin.KotlinX.Coroutines.Android => 0x4c071bea => 292
	i32 1278448581, ; 190: Xamarin.AndroidX.Annotation.Jvm => 0x4c3393c5 => 219
	i32 1292207520, ; 191: SQLitePCLRaw.core.dll => 0x4d0585a0 => 208
	i32 1293217323, ; 192: Xamarin.AndroidX.DrawerLayout.dll => 0x4d14ee2b => 238
	i32 1308624726, ; 193: hr\Microsoft.Maui.Controls.resources.dll => 0x4e000756 => 305
	i32 1309188875, ; 194: System.Private.DataContractSerialization => 0x4e08a30b => 85
	i32 1322716291, ; 195: Xamarin.AndroidX.Window.dll => 0x4ed70c83 => 280
	i32 1324164729, ; 196: System.Linq => 0x4eed2679 => 61
	i32 1335329327, ; 197: System.Runtime.Serialization.Json.dll => 0x4f97822f => 112
	i32 1336711579, ; 198: zh-HK\Microsoft.Maui.Controls.resources.dll => 0x4fac999b => 325
	i32 1364015309, ; 199: System.IO => 0x514d38cd => 57
	i32 1373134921, ; 200: zh-Hans\Microsoft.Maui.Controls.resources => 0x51d86049 => 326
	i32 1376866003, ; 201: Xamarin.AndroidX.SavedState => 0x52114ed3 => 267
	i32 1379779777, ; 202: System.Resources.ResourceManager => 0x523dc4c1 => 99
	i32 1402170036, ; 203: System.Configuration.dll => 0x53936ab4 => 19
	i32 1406073936, ; 204: Xamarin.AndroidX.CoordinatorLayout => 0x53cefc50 => 231
	i32 1408764838, ; 205: System.Runtime.Serialization.Formatters.dll => 0x53f80ba6 => 111
	i32 1411638395, ; 206: System.Runtime.CompilerServices.Unsafe => 0x5423e47b => 101
	i32 1422545099, ; 207: System.Runtime.CompilerServices.VisualC => 0x54ca50cb => 102
	i32 1430672901, ; 208: ar\Microsoft.Maui.Controls.resources => 0x55465605 => 294
	i32 1434145427, ; 209: System.Runtime.Handles => 0x557b5293 => 104
	i32 1435222561, ; 210: Xamarin.Google.Crypto.Tink.Android.dll => 0x558bc221 => 284
	i32 1439761251, ; 211: System.Net.Quic.dll => 0x55d10363 => 71
	i32 1452070440, ; 212: System.Formats.Asn1.dll => 0x568cd628 => 38
	i32 1453312822, ; 213: System.Diagnostics.Tools.dll => 0x569fcb36 => 32
	i32 1457743152, ; 214: System.Runtime.Extensions.dll => 0x56e36530 => 103
	i32 1458022317, ; 215: System.Net.Security.dll => 0x56e7a7ad => 73
	i32 1461004990, ; 216: es\Microsoft.Maui.Controls.resources => 0x57152abe => 300
	i32 1461234159, ; 217: System.Collections.Immutable.dll => 0x5718a9ef => 9
	i32 1461719063, ; 218: System.Security.Cryptography.OpenSsl => 0x57201017 => 123
	i32 1462112819, ; 219: System.IO.Compression.dll => 0x57261233 => 46
	i32 1469204771, ; 220: Xamarin.AndroidX.AppCompat.AppCompatResources => 0x57924923 => 221
	i32 1470490898, ; 221: Microsoft.Extensions.Primitives => 0x57a5e912 => 200
	i32 1479771757, ; 222: System.Collections.Immutable => 0x5833866d => 9
	i32 1480492111, ; 223: System.IO.Compression.Brotli.dll => 0x583e844f => 43
	i32 1487239319, ; 224: Microsoft.Win32.Primitives => 0x58a57897 => 4
	i32 1490025113, ; 225: Xamarin.AndroidX.SavedState.SavedState.Ktx.dll => 0x58cffa99 => 268
	i32 1490351284, ; 226: Microsoft.Data.Sqlite.dll => 0x58d4f4b4 => 179
	i32 1521091094, ; 227: Microsoft.Extensions.FileSystemGlobbing => 0x5aaa0216 => 195
	i32 1526286932, ; 228: vi\Microsoft.Maui.Controls.resources.dll => 0x5af94a54 => 324
	i32 1536373174, ; 229: System.Diagnostics.TextWriterTraceListener => 0x5b9331b6 => 31
	i32 1542894362, ; 230: Persistence => 0x5bf6b31a => 330
	i32 1543031311, ; 231: System.Text.RegularExpressions.dll => 0x5bf8ca0f => 138
	i32 1543355203, ; 232: System.Reflection.Emit.dll => 0x5bfdbb43 => 92
	i32 1550322496, ; 233: System.Reflection.Extensions.dll => 0x5c680b40 => 93
	i32 1560059367, ; 234: Persistence.dll => 0x5cfc9de7 => 330
	i32 1565862583, ; 235: System.IO.FileSystem.Primitives => 0x5d552ab7 => 49
	i32 1566207040, ; 236: System.Threading.Tasks.Dataflow.dll => 0x5d5a6c40 => 141
	i32 1573704789, ; 237: System.Runtime.Serialization.Json => 0x5dccd455 => 112
	i32 1580037396, ; 238: System.Threading.Overlapped => 0x5e2d7514 => 140
	i32 1582372066, ; 239: Xamarin.AndroidX.DocumentFile.dll => 0x5e5114e2 => 237
	i32 1592978981, ; 240: System.Runtime.Serialization.dll => 0x5ef2ee25 => 115
	i32 1597949149, ; 241: Xamarin.Google.ErrorProne.Annotations => 0x5f3ec4dd => 285
	i32 1601112923, ; 242: System.Xml.Serialization => 0x5f6f0b5b => 157
	i32 1604827217, ; 243: System.Net.WebClient => 0x5fa7b851 => 76
	i32 1618516317, ; 244: System.Net.WebSockets.Client.dll => 0x6078995d => 79
	i32 1622152042, ; 245: Xamarin.AndroidX.Loader.dll => 0x60b0136a => 257
	i32 1622358360, ; 246: System.Dynamic.Runtime => 0x60b33958 => 37
	i32 1624863272, ; 247: Xamarin.AndroidX.ViewPager2 => 0x60d97228 => 279
	i32 1632842087, ; 248: Microsoft.Extensions.Configuration.Json => 0x61533167 => 189
	i32 1634654947, ; 249: CommunityToolkit.Maui.Core.dll => 0x616edae3 => 174
	i32 1635184631, ; 250: Xamarin.AndroidX.Emoji2.ViewsHelper => 0x6176eff7 => 241
	i32 1636350590, ; 251: Xamarin.AndroidX.CursorAdapter => 0x6188ba7e => 234
	i32 1639515021, ; 252: System.Net.Http.dll => 0x61b9038d => 64
	i32 1639986890, ; 253: System.Text.RegularExpressions => 0x61c036ca => 138
	i32 1641389582, ; 254: System.ComponentModel.EventBasedAsync.dll => 0x61d59e0e => 15
	i32 1657153582, ; 255: System.Runtime => 0x62c6282e => 116
	i32 1658241508, ; 256: Xamarin.AndroidX.Tracing.Tracing.dll => 0x62d6c1e4 => 273
	i32 1658251792, ; 257: Xamarin.Google.Android.Material.dll => 0x62d6ea10 => 282
	i32 1670060433, ; 258: Xamarin.AndroidX.ConstraintLayout => 0x638b1991 => 229
	i32 1675553242, ; 259: System.IO.FileSystem.DriveInfo.dll => 0x63dee9da => 48
	i32 1677501392, ; 260: System.Net.Primitives.dll => 0x63fca3d0 => 70
	i32 1678508291, ; 261: System.Net.WebSockets => 0x640c0103 => 80
	i32 1679769178, ; 262: System.Security.Cryptography => 0x641f3e5a => 126
	i32 1688112883, ; 263: Microsoft.Data.Sqlite => 0x649e8ef3 => 179
	i32 1689493916, ; 264: Microsoft.EntityFrameworkCore.dll => 0x64b3a19c => 180
	i32 1691477237, ; 265: System.Reflection.Metadata => 0x64d1e4f5 => 94
	i32 1696967625, ; 266: System.Security.Cryptography.Csp => 0x6525abc9 => 121
	i32 1698840827, ; 267: Xamarin.Kotlin.StdLib.Common => 0x654240fb => 289
	i32 1701541528, ; 268: System.Diagnostics.Debug.dll => 0x656b7698 => 26
	i32 1711441057, ; 269: SQLitePCLRaw.lib.e_sqlite3.android => 0x660284a1 => 209
	i32 1720223769, ; 270: Xamarin.AndroidX.Lifecycle.LiveData.Core.Ktx => 0x66888819 => 250
	i32 1726116996, ; 271: System.Reflection.dll => 0x66e27484 => 97
	i32 1728033016, ; 272: System.Diagnostics.FileVersionInfo.dll => 0x66ffb0f8 => 28
	i32 1729485958, ; 273: Xamarin.AndroidX.CardView.dll => 0x6715dc86 => 225
	i32 1743415430, ; 274: ca\Microsoft.Maui.Controls.resources => 0x67ea6886 => 295
	i32 1744735666, ; 275: System.Transactions.Local.dll => 0x67fe8db2 => 149
	i32 1746316138, ; 276: Mono.Android.Export => 0x6816ab6a => 169
	i32 1750313021, ; 277: Microsoft.Win32.Primitives.dll => 0x6853a83d => 4
	i32 1758240030, ; 278: System.Resources.Reader.dll => 0x68cc9d1e => 98
	i32 1763938596, ; 279: System.Diagnostics.TraceSource.dll => 0x69239124 => 33
	i32 1765942094, ; 280: System.Reflection.Extensions => 0x6942234e => 93
	i32 1766324549, ; 281: Xamarin.AndroidX.SwipeRefreshLayout => 0x6947f945 => 272
	i32 1770582343, ; 282: Microsoft.Extensions.Logging.dll => 0x6988f147 => 196
	i32 1776026572, ; 283: System.Core.dll => 0x69dc03cc => 21
	i32 1777075843, ; 284: System.Globalization.Extensions.dll => 0x69ec0683 => 41
	i32 1780572499, ; 285: Mono.Android.Runtime.dll => 0x6a216153 => 170
	i32 1782862114, ; 286: ms\Microsoft.Maui.Controls.resources => 0x6a445122 => 311
	i32 1788241197, ; 287: Xamarin.AndroidX.Fragment => 0x6a96652d => 243
	i32 1793755602, ; 288: he\Microsoft.Maui.Controls.resources => 0x6aea89d2 => 303
	i32 1808609942, ; 289: Xamarin.AndroidX.Loader => 0x6bcd3296 => 257
	i32 1813058853, ; 290: Xamarin.Kotlin.StdLib.dll => 0x6c111525 => 288
	i32 1813201214, ; 291: Xamarin.Google.Android.Material => 0x6c13413e => 282
	i32 1818569960, ; 292: Xamarin.AndroidX.Navigation.UI.dll => 0x6c652ce8 => 262
	i32 1818787751, ; 293: Microsoft.VisualBasic.Core => 0x6c687fa7 => 2
	i32 1824175904, ; 294: System.Text.Encoding.Extensions => 0x6cbab720 => 134
	i32 1824722060, ; 295: System.Runtime.Serialization.Formatters => 0x6cc30c8c => 111
	i32 1828688058, ; 296: Microsoft.Extensions.Logging.Abstractions.dll => 0x6cff90ba => 197
	i32 1847515442, ; 297: Xamarin.Android.Glide.Annotations => 0x6e1ed932 => 212
	i32 1853025655, ; 298: sv\Microsoft.Maui.Controls.resources => 0x6e72ed77 => 320
	i32 1858542181, ; 299: System.Linq.Expressions => 0x6ec71a65 => 58
	i32 1870277092, ; 300: System.Reflection.Primitives => 0x6f7a29e4 => 95
	i32 1875935024, ; 301: fr\Microsoft.Maui.Controls.resources => 0x6fd07f30 => 302
	i32 1879696579, ; 302: System.Formats.Tar.dll => 0x7009e4c3 => 39
	i32 1885316902, ; 303: Xamarin.AndroidX.Arch.Core.Runtime.dll => 0x705fa726 => 223
	i32 1886040351, ; 304: Microsoft.EntityFrameworkCore.Sqlite.dll => 0x706ab11f => 183
	i32 1888955245, ; 305: System.Diagnostics.Contracts => 0x70972b6d => 25
	i32 1889954781, ; 306: System.Reflection.Metadata.dll => 0x70a66bdd => 94
	i32 1893218855, ; 307: cs\Microsoft.Maui.Controls.resources.dll => 0x70d83a27 => 296
	i32 1898237753, ; 308: System.Reflection.DispatchProxy => 0x7124cf39 => 89
	i32 1900610850, ; 309: System.Resources.ResourceManager.dll => 0x71490522 => 99
	i32 1910275211, ; 310: System.Collections.NonGeneric.dll => 0x71dc7c8b => 10
	i32 1939592360, ; 311: System.Private.Xml.Linq => 0x739bd4a8 => 87
	i32 1953182387, ; 312: id\Microsoft.Maui.Controls.resources.dll => 0x746b32b3 => 307
	i32 1956758971, ; 313: System.Resources.Writer => 0x74a1c5bb => 100
	i32 1961813231, ; 314: Xamarin.AndroidX.Security.SecurityCrypto.dll => 0x74eee4ef => 269
	i32 1968388702, ; 315: Microsoft.Extensions.Configuration.dll => 0x75533a5e => 186
	i32 1983156543, ; 316: Xamarin.Kotlin.StdLib.Common.dll => 0x7634913f => 289
	i32 1985761444, ; 317: Xamarin.Android.Glide.GifDecoder => 0x765c50a4 => 214
	i32 2003115576, ; 318: el\Microsoft.Maui.Controls.resources => 0x77651e38 => 299
	i32 2011961780, ; 319: System.Buffers.dll => 0x77ec19b4 => 7
	i32 2014489277, ; 320: Microsoft.EntityFrameworkCore.Sqlite => 0x7812aabd => 183
	i32 2019465201, ; 321: Xamarin.AndroidX.Lifecycle.ViewModel => 0x785e97f1 => 254
	i32 2031763787, ; 322: Xamarin.Android.Glide => 0x791a414b => 211
	i32 2045470958, ; 323: System.Private.Xml => 0x79eb68ee => 88
	i32 2055257422, ; 324: Xamarin.AndroidX.Lifecycle.LiveData.Core.dll => 0x7a80bd4e => 249
	i32 2060060697, ; 325: System.Windows.dll => 0x7aca0819 => 154
	i32 2066184531, ; 326: de\Microsoft.Maui.Controls.resources => 0x7b277953 => 298
	i32 2070888862, ; 327: System.Diagnostics.TraceSource => 0x7b6f419e => 33
	i32 2072397586, ; 328: Microsoft.Extensions.FileProviders.Physical => 0x7b864712 => 194
	i32 2079903147, ; 329: System.Runtime.dll => 0x7bf8cdab => 116
	i32 2090596640, ; 330: System.Numerics.Vectors => 0x7c9bf920 => 82
	i32 2103459038, ; 331: SQLitePCLRaw.provider.e_sqlite3.dll => 0x7d603cde => 210
	i32 2127167465, ; 332: System.Console => 0x7ec9ffe9 => 20
	i32 2142473426, ; 333: System.Collections.Specialized => 0x7fb38cd2 => 11
	i32 2143790110, ; 334: System.Xml.XmlSerializer.dll => 0x7fc7a41e => 162
	i32 2146852085, ; 335: Microsoft.VisualBasic.dll => 0x7ff65cf5 => 3
	i32 2159891885, ; 336: Microsoft.Maui => 0x80bd55ad => 204
	i32 2169148018, ; 337: hu\Microsoft.Maui.Controls.resources => 0x814a9272 => 306
	i32 2179373486, ; 338: UI => 0x81e699ae => 0
	i32 2181898931, ; 339: Microsoft.Extensions.Options.dll => 0x820d22b3 => 199
	i32 2192057212, ; 340: Microsoft.Extensions.Logging.Abstractions => 0x82a8237c => 197
	i32 2193016926, ; 341: System.ObjectModel.dll => 0x82b6c85e => 84
	i32 2197979891, ; 342: Microsoft.Extensions.DependencyModel.dll => 0x830282f3 => 192
	i32 2201107256, ; 343: Xamarin.KotlinX.Coroutines.Core.Jvm.dll => 0x83323b38 => 293
	i32 2201231467, ; 344: System.Net.Http => 0x8334206b => 64
	i32 2207618523, ; 345: it\Microsoft.Maui.Controls.resources => 0x839595db => 308
	i32 2217644978, ; 346: Xamarin.AndroidX.VectorDrawable.Animated.dll => 0x842e93b2 => 276
	i32 2222056684, ; 347: System.Threading.Tasks.Parallel => 0x8471e4ec => 143
	i32 2244775296, ; 348: Xamarin.AndroidX.LocalBroadcastManager => 0x85cc8d80 => 258
	i32 2252106437, ; 349: System.Xml.Serialization.dll => 0x863c6ac5 => 157
	i32 2252897993, ; 350: Microsoft.EntityFrameworkCore => 0x86487ec9 => 180
	i32 2256313426, ; 351: System.Globalization.Extensions => 0x867c9c52 => 41
	i32 2265110946, ; 352: System.Security.AccessControl.dll => 0x8702d9a2 => 117
	i32 2266799131, ; 353: Microsoft.Extensions.Configuration.Abstractions => 0x871c9c1b => 187
	i32 2267999099, ; 354: Xamarin.Android.Glide.DiskLruCache.dll => 0x872eeb7b => 213
	i32 2279755925, ; 355: Xamarin.AndroidX.RecyclerView.dll => 0x87e25095 => 265
	i32 2293034957, ; 356: System.ServiceModel.Web.dll => 0x88acefcd => 131
	i32 2295906218, ; 357: System.Net.Sockets => 0x88d8bfaa => 75
	i32 2298471582, ; 358: System.Net.Mail => 0x88ffe49e => 66
	i32 2303942373, ; 359: nb\Microsoft.Maui.Controls.resources => 0x89535ee5 => 312
	i32 2305521784, ; 360: System.Private.CoreLib.dll => 0x896b7878 => 172
	i32 2315684594, ; 361: Xamarin.AndroidX.Annotation.dll => 0x8a068af2 => 217
	i32 2320631194, ; 362: System.Threading.Tasks.Parallel.dll => 0x8a52059a => 143
	i32 2340441535, ; 363: System.Runtime.InteropServices.RuntimeInformation.dll => 0x8b804dbf => 106
	i32 2344264397, ; 364: System.ValueTuple => 0x8bbaa2cd => 151
	i32 2353062107, ; 365: System.Net.Primitives => 0x8c40e0db => 70
	i32 2363376857, ; 366: Application.dll => 0x8cde44d9 => 328
	i32 2366048013, ; 367: hu\Microsoft.Maui.Controls.resources.dll => 0x8d07070d => 306
	i32 2368005991, ; 368: System.Xml.ReaderWriter.dll => 0x8d24e767 => 156
	i32 2371007202, ; 369: Microsoft.Extensions.Configuration => 0x8d52b2e2 => 186
	i32 2378619854, ; 370: System.Security.Cryptography.Csp.dll => 0x8dc6dbce => 121
	i32 2383496789, ; 371: System.Security.Principal.Windows.dll => 0x8e114655 => 127
	i32 2395872292, ; 372: id\Microsoft.Maui.Controls.resources => 0x8ece1c24 => 307
	i32 2400516001, ; 373: Domain => 0x8f14f7a1 => 329
	i32 2401565422, ; 374: System.Web.HttpUtility => 0x8f24faee => 152
	i32 2403452196, ; 375: Xamarin.AndroidX.Emoji2.dll => 0x8f41c524 => 240
	i32 2421380589, ; 376: System.Threading.Tasks.Dataflow => 0x905355ed => 141
	i32 2423080555, ; 377: Xamarin.AndroidX.Collection.Ktx.dll => 0x906d466b => 227
	i32 2427813419, ; 378: hi\Microsoft.Maui.Controls.resources => 0x90b57e2b => 304
	i32 2435356389, ; 379: System.Console.dll => 0x912896e5 => 20
	i32 2435904999, ; 380: System.ComponentModel.DataAnnotations.dll => 0x9130f5e7 => 14
	i32 2454642406, ; 381: System.Text.Encoding.dll => 0x924edee6 => 135
	i32 2458678730, ; 382: System.Net.Sockets.dll => 0x928c75ca => 75
	i32 2459001652, ; 383: System.Linq.Parallel.dll => 0x92916334 => 59
	i32 2465273461, ; 384: SQLitePCLRaw.batteries_v2.dll => 0x92f11675 => 207
	i32 2465532216, ; 385: Xamarin.AndroidX.ConstraintLayout.Core.dll => 0x92f50938 => 230
	i32 2471841756, ; 386: netstandard.dll => 0x93554fdc => 167
	i32 2475788418, ; 387: Java.Interop.dll => 0x93918882 => 168
	i32 2480646305, ; 388: Microsoft.Maui.Controls => 0x93dba8a1 => 202
	i32 2483903535, ; 389: System.ComponentModel.EventBasedAsync => 0x940d5c2f => 15
	i32 2484371297, ; 390: System.Net.ServicePoint => 0x94147f61 => 74
	i32 2490993605, ; 391: System.AppContext.dll => 0x94798bc5 => 6
	i32 2501346920, ; 392: System.Data.DataSetExtensions => 0x95178668 => 23
	i32 2503351294, ; 393: ko\Microsoft.Maui.Controls.resources.dll => 0x95361bfe => 310
	i32 2505896520, ; 394: Xamarin.AndroidX.Lifecycle.Runtime.dll => 0x955cf248 => 252
	i32 2522472828, ; 395: Xamarin.Android.Glide.dll => 0x9659e17c => 211
	i32 2538310050, ; 396: System.Reflection.Emit.Lightweight.dll => 0x974b89a2 => 91
	i32 2550873716, ; 397: hr\Microsoft.Maui.Controls.resources => 0x980b3e74 => 305
	i32 2562349572, ; 398: Microsoft.CSharp => 0x98ba5a04 => 1
	i32 2570120770, ; 399: System.Text.Encodings.Web => 0x9930ee42 => 136
	i32 2576534780, ; 400: ja\Microsoft.Maui.Controls.resources.dll => 0x9992ccfc => 309
	i32 2581783588, ; 401: Xamarin.AndroidX.Lifecycle.Runtime.Ktx => 0x99e2e424 => 253
	i32 2581819634, ; 402: Xamarin.AndroidX.VectorDrawable.dll => 0x99e370f2 => 275
	i32 2585220780, ; 403: System.Text.Encoding.Extensions.dll => 0x9a1756ac => 134
	i32 2585805581, ; 404: System.Net.Ping => 0x9a20430d => 69
	i32 2589602615, ; 405: System.Threading.ThreadPool => 0x9a5a3337 => 146
	i32 2592341985, ; 406: Microsoft.Extensions.FileProviders.Abstractions => 0x9a83ffe1 => 193
	i32 2593496499, ; 407: pl\Microsoft.Maui.Controls.resources => 0x9a959db3 => 314
	i32 2605712449, ; 408: Xamarin.KotlinX.Coroutines.Core.Jvm => 0x9b500441 => 293
	i32 2615233544, ; 409: Xamarin.AndroidX.Fragment.Ktx => 0x9be14c08 => 244
	i32 2615519321, ; 410: MediatR => 0x9be5a859 => 177
	i32 2616218305, ; 411: Microsoft.Extensions.Logging.Debug.dll => 0x9bf052c1 => 198
	i32 2617129537, ; 412: System.Private.Xml.dll => 0x9bfe3a41 => 88
	i32 2618712057, ; 413: System.Reflection.TypeExtensions.dll => 0x9c165ff9 => 96
	i32 2620871830, ; 414: Xamarin.AndroidX.CursorAdapter.dll => 0x9c375496 => 234
	i32 2624644809, ; 415: Xamarin.AndroidX.DynamicAnimation => 0x9c70e6c9 => 239
	i32 2626831493, ; 416: ja\Microsoft.Maui.Controls.resources => 0x9c924485 => 309
	i32 2627185994, ; 417: System.Diagnostics.TextWriterTraceListener.dll => 0x9c97ad4a => 31
	i32 2629843544, ; 418: System.IO.Compression.ZipFile.dll => 0x9cc03a58 => 45
	i32 2633051222, ; 419: Xamarin.AndroidX.Lifecycle.LiveData => 0x9cf12c56 => 248
	i32 2634653062, ; 420: Microsoft.EntityFrameworkCore.Relational.dll => 0x9d099d86 => 182
	i32 2663391936, ; 421: Xamarin.Android.Glide.DiskLruCache => 0x9ec022c0 => 213
	i32 2663698177, ; 422: System.Runtime.Loader => 0x9ec4cf01 => 109
	i32 2664396074, ; 423: System.Xml.XDocument.dll => 0x9ecf752a => 158
	i32 2665622720, ; 424: System.Drawing.Primitives => 0x9ee22cc0 => 35
	i32 2676780864, ; 425: System.Data.Common.dll => 0x9f8c6f40 => 22
	i32 2677943566, ; 426: MediatR.Contracts.dll => 0x9f9e2d0e => 178
	i32 2686887180, ; 427: System.Runtime.Serialization.Xml.dll => 0xa026a50c => 114
	i32 2693849962, ; 428: System.IO.dll => 0xa090e36a => 57
	i32 2701096212, ; 429: Xamarin.AndroidX.Tracing.Tracing => 0xa0ff7514 => 273
	i32 2715334215, ; 430: System.Threading.Tasks.dll => 0xa1d8b647 => 144
	i32 2717744543, ; 431: System.Security.Claims => 0xa1fd7d9f => 118
	i32 2719963679, ; 432: System.Security.Cryptography.Cng.dll => 0xa21f5a1f => 120
	i32 2724373263, ; 433: System.Runtime.Numerics.dll => 0xa262a30f => 110
	i32 2732626843, ; 434: Xamarin.AndroidX.Activity => 0xa2e0939b => 215
	i32 2735172069, ; 435: System.Threading.Channels => 0xa30769e5 => 139
	i32 2737747696, ; 436: Xamarin.AndroidX.AppCompat.AppCompatResources.dll => 0xa32eb6f0 => 221
	i32 2740698338, ; 437: ca\Microsoft.Maui.Controls.resources.dll => 0xa35bbce2 => 295
	i32 2740948882, ; 438: System.IO.Pipes.AccessControl => 0xa35f8f92 => 54
	i32 2748088231, ; 439: System.Runtime.InteropServices.JavaScript => 0xa3cc7fa7 => 105
	i32 2752995522, ; 440: pt-BR\Microsoft.Maui.Controls.resources => 0xa41760c2 => 315
	i32 2758225723, ; 441: Microsoft.Maui.Controls.Xaml => 0xa4672f3b => 203
	i32 2764765095, ; 442: Microsoft.Maui.dll => 0xa4caf7a7 => 204
	i32 2765824710, ; 443: System.Text.Encoding.CodePages.dll => 0xa4db22c6 => 133
	i32 2770495804, ; 444: Xamarin.Jetbrains.Annotations.dll => 0xa522693c => 287
	i32 2778768386, ; 445: Xamarin.AndroidX.ViewPager.dll => 0xa5a0a402 => 278
	i32 2779977773, ; 446: Xamarin.AndroidX.ResourceInspection.Annotation.dll => 0xa5b3182d => 266
	i32 2785988530, ; 447: th\Microsoft.Maui.Controls.resources => 0xa60ecfb2 => 321
	i32 2788224221, ; 448: Xamarin.AndroidX.Fragment.Ktx.dll => 0xa630ecdd => 244
	i32 2801831435, ; 449: Microsoft.Maui.Graphics => 0xa7008e0b => 206
	i32 2803228030, ; 450: System.Xml.XPath.XDocument.dll => 0xa715dd7e => 159
	i32 2810250172, ; 451: Xamarin.AndroidX.CoordinatorLayout.dll => 0xa78103bc => 231
	i32 2819470561, ; 452: System.Xml.dll => 0xa80db4e1 => 163
	i32 2821205001, ; 453: System.ServiceProcess.dll => 0xa8282c09 => 132
	i32 2821294376, ; 454: Xamarin.AndroidX.ResourceInspection.Annotation => 0xa8298928 => 266
	i32 2824502124, ; 455: System.Xml.XmlDocument => 0xa85a7b6c => 161
	i32 2838993487, ; 456: Xamarin.AndroidX.Lifecycle.ViewModel.Ktx.dll => 0xa9379a4f => 255
	i32 2847789619, ; 457: Microsoft.EntityFrameworkCore.Relational => 0xa9bdd233 => 182
	i32 2849599387, ; 458: System.Threading.Overlapped.dll => 0xa9d96f9b => 140
	i32 2853208004, ; 459: Xamarin.AndroidX.ViewPager => 0xaa107fc4 => 278
	i32 2855708567, ; 460: Xamarin.AndroidX.Transition => 0xaa36a797 => 274
	i32 2861098320, ; 461: Mono.Android.Export.dll => 0xaa88e550 => 169
	i32 2861189240, ; 462: Microsoft.Maui.Essentials => 0xaa8a4878 => 205
	i32 2868488919, ; 463: CommunityToolkit.Maui.Core => 0xaaf9aad7 => 174
	i32 2870099610, ; 464: Xamarin.AndroidX.Activity.Ktx.dll => 0xab123e9a => 216
	i32 2875164099, ; 465: Jsr305Binding.dll => 0xab5f85c3 => 283
	i32 2875220617, ; 466: System.Globalization.Calendars.dll => 0xab606289 => 40
	i32 2884993177, ; 467: Xamarin.AndroidX.ExifInterface => 0xabf58099 => 242
	i32 2887636118, ; 468: System.Net.dll => 0xac1dd496 => 81
	i32 2899753641, ; 469: System.IO.UnmanagedMemoryStream => 0xacd6baa9 => 56
	i32 2900621748, ; 470: System.Dynamic.Runtime.dll => 0xace3f9b4 => 37
	i32 2901442782, ; 471: System.Reflection => 0xacf080de => 97
	i32 2905242038, ; 472: mscorlib.dll => 0xad2a79b6 => 166
	i32 2909740682, ; 473: System.Private.CoreLib => 0xad6f1e8a => 172
	i32 2911054922, ; 474: Microsoft.Extensions.FileProviders.Physical.dll => 0xad832c4a => 194
	i32 2916838712, ; 475: Xamarin.AndroidX.ViewPager2.dll => 0xaddb6d38 => 279
	i32 2919462931, ; 476: System.Numerics.Vectors.dll => 0xae037813 => 82
	i32 2921128767, ; 477: Xamarin.AndroidX.Annotation.Experimental.dll => 0xae1ce33f => 218
	i32 2936416060, ; 478: System.Resources.Reader => 0xaf06273c => 98
	i32 2940926066, ; 479: System.Diagnostics.StackTrace.dll => 0xaf4af872 => 30
	i32 2942453041, ; 480: System.Xml.XPath.XDocument => 0xaf624531 => 159
	i32 2959614098, ; 481: System.ComponentModel.dll => 0xb0682092 => 18
	i32 2968338931, ; 482: System.Security.Principal.Windows => 0xb0ed41f3 => 127
	i32 2972252294, ; 483: System.Security.Cryptography.Algorithms.dll => 0xb128f886 => 119
	i32 2978675010, ; 484: Xamarin.AndroidX.DrawerLayout => 0xb18af942 => 238
	i32 2987532451, ; 485: Xamarin.AndroidX.Security.SecurityCrypto => 0xb21220a3 => 269
	i32 2996846495, ; 486: Xamarin.AndroidX.Lifecycle.Process.dll => 0xb2a03f9f => 251
	i32 3016983068, ; 487: Xamarin.AndroidX.Startup.StartupRuntime => 0xb3d3821c => 271
	i32 3023353419, ; 488: WindowsBase.dll => 0xb434b64b => 165
	i32 3024354802, ; 489: Xamarin.AndroidX.Legacy.Support.Core.Utils => 0xb443fdf2 => 246
	i32 3038032645, ; 490: _Microsoft.Android.Resource.Designer.dll => 0xb514b305 => 331
	i32 3053864966, ; 491: fi\Microsoft.Maui.Controls.resources.dll => 0xb6064806 => 301
	i32 3056245963, ; 492: Xamarin.AndroidX.SavedState.SavedState.Ktx => 0xb62a9ccb => 268
	i32 3057625584, ; 493: Xamarin.AndroidX.Navigation.Common => 0xb63fa9f0 => 259
	i32 3059408633, ; 494: Mono.Android.Runtime => 0xb65adef9 => 170
	i32 3059793426, ; 495: System.ComponentModel.Primitives => 0xb660be12 => 16
	i32 3069363400, ; 496: Microsoft.Extensions.Caching.Abstractions.dll => 0xb6f2c4c8 => 184
	i32 3075834255, ; 497: System.Threading.Tasks => 0xb755818f => 144
	i32 3090735792, ; 498: System.Security.Cryptography.X509Certificates.dll => 0xb838e2b0 => 125
	i32 3099732863, ; 499: System.Security.Claims.dll => 0xb8c22b7f => 118
	i32 3103600923, ; 500: System.Formats.Asn1 => 0xb8fd311b => 38
	i32 3111772706, ; 501: System.Runtime.Serialization => 0xb979e222 => 115
	i32 3121463068, ; 502: System.IO.FileSystem.AccessControl.dll => 0xba0dbf1c => 47
	i32 3124832203, ; 503: System.Threading.Tasks.Extensions => 0xba4127cb => 142
	i32 3132293585, ; 504: System.Security.AccessControl => 0xbab301d1 => 117
	i32 3147165239, ; 505: System.Diagnostics.Tracing.dll => 0xbb95ee37 => 34
	i32 3148237826, ; 506: GoogleGson.dll => 0xbba64c02 => 176
	i32 3159123045, ; 507: System.Reflection.Primitives.dll => 0xbc4c6465 => 95
	i32 3160747431, ; 508: System.IO.MemoryMappedFiles => 0xbc652da7 => 53
	i32 3178803400, ; 509: Xamarin.AndroidX.Navigation.Fragment.dll => 0xbd78b0c8 => 260
	i32 3192346100, ; 510: System.Security.SecureString => 0xbe4755f4 => 129
	i32 3193515020, ; 511: System.Web => 0xbe592c0c => 153
	i32 3195844289, ; 512: Microsoft.Extensions.Caching.Abstractions => 0xbe7cb6c1 => 184
	i32 3204380047, ; 513: System.Data.dll => 0xbefef58f => 24
	i32 3209718065, ; 514: System.Xml.XmlDocument.dll => 0xbf506931 => 161
	i32 3211777861, ; 515: Xamarin.AndroidX.DocumentFile => 0xbf6fd745 => 237
	i32 3220365878, ; 516: System.Threading => 0xbff2e236 => 148
	i32 3226221578, ; 517: System.Runtime.Handles.dll => 0xc04c3c0a => 104
	i32 3251039220, ; 518: System.Reflection.DispatchProxy.dll => 0xc1c6ebf4 => 89
	i32 3258312781, ; 519: Xamarin.AndroidX.CardView => 0xc235e84d => 225
	i32 3265493905, ; 520: System.Linq.Queryable.dll => 0xc2a37b91 => 60
	i32 3265893370, ; 521: System.Threading.Tasks.Extensions.dll => 0xc2a993fa => 142
	i32 3277815716, ; 522: System.Resources.Writer.dll => 0xc35f7fa4 => 100
	i32 3279906254, ; 523: Microsoft.Win32.Registry.dll => 0xc37f65ce => 5
	i32 3280506390, ; 524: System.ComponentModel.Annotations.dll => 0xc3888e16 => 13
	i32 3290767353, ; 525: System.Security.Cryptography.Encoding => 0xc4251ff9 => 122
	i32 3299363146, ; 526: System.Text.Encoding => 0xc4a8494a => 135
	i32 3303498502, ; 527: System.Diagnostics.FileVersionInfo => 0xc4e76306 => 28
	i32 3305363605, ; 528: fi\Microsoft.Maui.Controls.resources => 0xc503d895 => 301
	i32 3316684772, ; 529: System.Net.Requests.dll => 0xc5b097e4 => 72
	i32 3317135071, ; 530: Xamarin.AndroidX.CustomView.dll => 0xc5b776df => 235
	i32 3317144872, ; 531: System.Data => 0xc5b79d28 => 24
	i32 3340431453, ; 532: Xamarin.AndroidX.Arch.Core.Runtime => 0xc71af05d => 223
	i32 3345895724, ; 533: Xamarin.AndroidX.ProfileInstaller.ProfileInstaller.dll => 0xc76e512c => 264
	i32 3346324047, ; 534: Xamarin.AndroidX.Navigation.Runtime => 0xc774da4f => 261
	i32 3357674450, ; 535: ru\Microsoft.Maui.Controls.resources => 0xc8220bd2 => 318
	i32 3358260929, ; 536: System.Text.Json => 0xc82afec1 => 137
	i32 3360279109, ; 537: SQLitePCLRaw.core => 0xc849ca45 => 208
	i32 3362336904, ; 538: Xamarin.AndroidX.Activity.Ktx => 0xc8693088 => 216
	i32 3362522851, ; 539: Xamarin.AndroidX.Core => 0xc86c06e3 => 232
	i32 3366347497, ; 540: Java.Interop => 0xc8a662e9 => 168
	i32 3374999561, ; 541: Xamarin.AndroidX.RecyclerView => 0xc92a6809 => 265
	i32 3381016424, ; 542: da\Microsoft.Maui.Controls.resources => 0xc9863768 => 297
	i32 3395150330, ; 543: System.Runtime.CompilerServices.Unsafe.dll => 0xca5de1fa => 101
	i32 3403906625, ; 544: System.Security.Cryptography.OpenSsl.dll => 0xcae37e41 => 123
	i32 3405233483, ; 545: Xamarin.AndroidX.CustomView.PoolingContainer => 0xcaf7bd4b => 236
	i32 3428513518, ; 546: Microsoft.Extensions.DependencyInjection.dll => 0xcc5af6ee => 190
	i32 3429136800, ; 547: System.Xml => 0xcc6479a0 => 163
	i32 3430777524, ; 548: netstandard => 0xcc7d82b4 => 167
	i32 3441283291, ; 549: Xamarin.AndroidX.DynamicAnimation.dll => 0xcd1dd0db => 239
	i32 3445260447, ; 550: System.Formats.Tar => 0xcd5a809f => 39
	i32 3452344032, ; 551: Microsoft.Maui.Controls.Compatibility.dll => 0xcdc696e0 => 201
	i32 3458724246, ; 552: pt\Microsoft.Maui.Controls.resources.dll => 0xce27f196 => 316
	i32 3471940407, ; 553: System.ComponentModel.TypeConverter.dll => 0xcef19b37 => 17
	i32 3476120550, ; 554: Mono.Android => 0xcf3163e6 => 171
	i32 3484440000, ; 555: ro\Microsoft.Maui.Controls.resources => 0xcfb055c0 => 317
	i32 3485117614, ; 556: System.Text.Json.dll => 0xcfbaacae => 137
	i32 3486566296, ; 557: System.Transactions => 0xcfd0c798 => 150
	i32 3493954962, ; 558: Xamarin.AndroidX.Concurrent.Futures.dll => 0xd0418592 => 228
	i32 3509114376, ; 559: System.Xml.Linq => 0xd128d608 => 155
	i32 3515174580, ; 560: System.Security.dll => 0xd1854eb4 => 130
	i32 3530912306, ; 561: System.Configuration => 0xd2757232 => 19
	i32 3539954161, ; 562: System.Net.HttpListener => 0xd2ff69f1 => 65
	i32 3560100363, ; 563: System.Threading.Timer => 0xd432d20b => 147
	i32 3570554715, ; 564: System.IO.FileSystem.AccessControl => 0xd4d2575b => 47
	i32 3580758918, ; 565: zh-HK\Microsoft.Maui.Controls.resources => 0xd56e0b86 => 325
	i32 3592228221, ; 566: zh-Hant\Microsoft.Maui.Controls.resources.dll => 0xd61d0d7d => 327
	i32 3597029428, ; 567: Xamarin.Android.Glide.GifDecoder.dll => 0xd6665034 => 214
	i32 3598340787, ; 568: System.Net.WebSockets.Client => 0xd67a52b3 => 79
	i32 3608519521, ; 569: System.Linq.dll => 0xd715a361 => 61
	i32 3624195450, ; 570: System.Runtime.InteropServices.RuntimeInformation => 0xd804d57a => 106
	i32 3627220390, ; 571: Xamarin.AndroidX.Print.dll => 0xd832fda6 => 263
	i32 3633644679, ; 572: Xamarin.AndroidX.Annotation.Experimental => 0xd8950487 => 218
	i32 3638274909, ; 573: System.IO.FileSystem.Primitives.dll => 0xd8dbab5d => 49
	i32 3641597786, ; 574: Xamarin.AndroidX.Lifecycle.LiveData.Core => 0xd90e5f5a => 249
	i32 3643446276, ; 575: tr\Microsoft.Maui.Controls.resources => 0xd92a9404 => 322
	i32 3643854240, ; 576: Xamarin.AndroidX.Navigation.Fragment => 0xd930cda0 => 260
	i32 3645089577, ; 577: System.ComponentModel.DataAnnotations => 0xd943a729 => 14
	i32 3657292374, ; 578: Microsoft.Extensions.Configuration.Abstractions.dll => 0xd9fdda56 => 187
	i32 3660523487, ; 579: System.Net.NetworkInformation => 0xda2f27df => 68
	i32 3672681054, ; 580: Mono.Android.dll => 0xdae8aa5e => 171
	i32 3682565725, ; 581: Xamarin.AndroidX.Browser => 0xdb7f7e5d => 224
	i32 3684561358, ; 582: Xamarin.AndroidX.Concurrent.Futures => 0xdb9df1ce => 228
	i32 3700866549, ; 583: System.Net.WebProxy.dll => 0xdc96bdf5 => 78
	i32 3706696989, ; 584: Xamarin.AndroidX.Core.Core.Ktx.dll => 0xdcefb51d => 233
	i32 3716563718, ; 585: System.Runtime.Intrinsics => 0xdd864306 => 108
	i32 3718780102, ; 586: Xamarin.AndroidX.Annotation => 0xdda814c6 => 217
	i32 3722202641, ; 587: Microsoft.Extensions.Configuration.Json.dll => 0xdddc4e11 => 189
	i32 3724971120, ; 588: Xamarin.AndroidX.Navigation.Common.dll => 0xde068c70 => 259
	i32 3732100267, ; 589: System.Net.NameResolution => 0xde7354ab => 67
	i32 3737834244, ; 590: System.Net.Http.Json.dll => 0xdecad304 => 63
	i32 3748608112, ; 591: System.Diagnostics.DiagnosticSource => 0xdf6f3870 => 27
	i32 3751444290, ; 592: System.Xml.XPath => 0xdf9a7f42 => 160
	i32 3751619990, ; 593: da\Microsoft.Maui.Controls.resources.dll => 0xdf9d2d96 => 297
	i32 3754567612, ; 594: SQLitePCLRaw.provider.e_sqlite3 => 0xdfca27bc => 210
	i32 3758424670, ; 595: Microsoft.Extensions.Configuration.FileExtensions => 0xe005025e => 188
	i32 3786282454, ; 596: Xamarin.AndroidX.Collection => 0xe1ae15d6 => 226
	i32 3792276235, ; 597: System.Collections.NonGeneric => 0xe2098b0b => 10
	i32 3800979733, ; 598: Microsoft.Maui.Controls.Compatibility => 0xe28e5915 => 201
	i32 3802395368, ; 599: System.Collections.Specialized.dll => 0xe2a3f2e8 => 11
	i32 3817368567, ; 600: CommunityToolkit.Maui.dll => 0xe3886bf7 => 173
	i32 3819260425, ; 601: System.Net.WebProxy => 0xe3a54a09 => 78
	i32 3823082795, ; 602: System.Security.Cryptography.dll => 0xe3df9d2b => 126
	i32 3829621856, ; 603: System.Numerics.dll => 0xe4436460 => 83
	i32 3841636137, ; 604: Microsoft.Extensions.DependencyInjection.Abstractions.dll => 0xe4fab729 => 191
	i32 3844307129, ; 605: System.Net.Mail.dll => 0xe52378b9 => 66
	i32 3849253459, ; 606: System.Runtime.InteropServices.dll => 0xe56ef253 => 107
	i32 3870376305, ; 607: System.Net.HttpListener.dll => 0xe6b14171 => 65
	i32 3873536506, ; 608: System.Security.Principal => 0xe6e179fa => 128
	i32 3875112723, ; 609: System.Security.Cryptography.Encoding.dll => 0xe6f98713 => 122
	i32 3885497537, ; 610: System.Net.WebHeaderCollection.dll => 0xe797fcc1 => 77
	i32 3885922214, ; 611: Xamarin.AndroidX.Transition.dll => 0xe79e77a6 => 274
	i32 3888767677, ; 612: Xamarin.AndroidX.ProfileInstaller.ProfileInstaller => 0xe7c9e2bd => 264
	i32 3896106733, ; 613: System.Collections.Concurrent.dll => 0xe839deed => 8
	i32 3896760992, ; 614: Xamarin.AndroidX.Core.dll => 0xe843daa0 => 232
	i32 3901907137, ; 615: Microsoft.VisualBasic.Core.dll => 0xe89260c1 => 2
	i32 3920221145, ; 616: nl\Microsoft.Maui.Controls.resources.dll => 0xe9a9d3d9 => 313
	i32 3920810846, ; 617: System.IO.Compression.FileSystem.dll => 0xe9b2d35e => 44
	i32 3921031405, ; 618: Xamarin.AndroidX.VersionedParcelable.dll => 0xe9b630ed => 277
	i32 3928044579, ; 619: System.Xml.ReaderWriter => 0xea213423 => 156
	i32 3930554604, ; 620: System.Security.Principal.dll => 0xea4780ec => 128
	i32 3931092270, ; 621: Xamarin.AndroidX.Navigation.UI => 0xea4fb52e => 262
	i32 3945713374, ; 622: System.Data.DataSetExtensions.dll => 0xeb2ecede => 23
	i32 3953953790, ; 623: System.Text.Encoding.CodePages => 0xebac8bfe => 133
	i32 3955647286, ; 624: Xamarin.AndroidX.AppCompat.dll => 0xebc66336 => 220
	i32 3959773229, ; 625: Xamarin.AndroidX.Lifecycle.Process => 0xec05582d => 251
	i32 4003436829, ; 626: System.Diagnostics.Process.dll => 0xee9f991d => 29
	i32 4015948917, ; 627: Xamarin.AndroidX.Annotation.Jvm.dll => 0xef5e8475 => 219
	i32 4025784931, ; 628: System.Memory => 0xeff49a63 => 62
	i32 4046471985, ; 629: Microsoft.Maui.Controls.Xaml.dll => 0xf1304331 => 203
	i32 4054681211, ; 630: System.Reflection.Emit.ILGeneration => 0xf1ad867b => 90
	i32 4068434129, ; 631: System.Private.Xml.Linq.dll => 0xf27f60d1 => 87
	i32 4073602200, ; 632: System.Threading.dll => 0xf2ce3c98 => 148
	i32 4091086043, ; 633: el\Microsoft.Maui.Controls.resources.dll => 0xf3d904db => 299
	i32 4094352644, ; 634: Microsoft.Maui.Essentials.dll => 0xf40add04 => 205
	i32 4099507663, ; 635: System.Drawing.dll => 0xf45985cf => 36
	i32 4100113165, ; 636: System.Private.Uri => 0xf462c30d => 86
	i32 4101593132, ; 637: Xamarin.AndroidX.Emoji2 => 0xf479582c => 240
	i32 4101842092, ; 638: Microsoft.Extensions.Caching.Memory => 0xf47d24ac => 185
	i32 4103439459, ; 639: uk\Microsoft.Maui.Controls.resources.dll => 0xf4958463 => 323
	i32 4126470640, ; 640: Microsoft.Extensions.DependencyInjection => 0xf5f4f1f0 => 190
	i32 4127667938, ; 641: System.IO.FileSystem.Watcher => 0xf60736e2 => 50
	i32 4130442656, ; 642: System.AppContext => 0xf6318da0 => 6
	i32 4147896353, ; 643: System.Reflection.Emit.ILGeneration.dll => 0xf73be021 => 90
	i32 4150914736, ; 644: uk\Microsoft.Maui.Controls.resources => 0xf769eeb0 => 323
	i32 4151237749, ; 645: System.Core => 0xf76edc75 => 21
	i32 4159265925, ; 646: System.Xml.XmlSerializer => 0xf7e95c85 => 162
	i32 4161255271, ; 647: System.Reflection.TypeExtensions => 0xf807b767 => 96
	i32 4164802419, ; 648: System.IO.FileSystem.Watcher.dll => 0xf83dd773 => 50
	i32 4181436372, ; 649: System.Runtime.Serialization.Primitives => 0xf93ba7d4 => 113
	i32 4182413190, ; 650: Xamarin.AndroidX.Lifecycle.ViewModelSavedState.dll => 0xf94a8f86 => 256
	i32 4185676441, ; 651: System.Security => 0xf97c5a99 => 130
	i32 4196529839, ; 652: System.Net.WebClient.dll => 0xfa21f6af => 76
	i32 4213026141, ; 653: System.Diagnostics.DiagnosticSource.dll => 0xfb1dad5d => 27
	i32 4249188766, ; 654: nb\Microsoft.Maui.Controls.resources.dll => 0xfd45799e => 312
	i32 4256097574, ; 655: Xamarin.AndroidX.Core.Core.Ktx => 0xfdaee526 => 233
	i32 4258378803, ; 656: Xamarin.AndroidX.Lifecycle.ViewModel.Ktx => 0xfdd1b433 => 255
	i32 4260525087, ; 657: System.Buffers => 0xfdf2741f => 7
	i32 4271975918, ; 658: Microsoft.Maui.Controls.dll => 0xfea12dee => 202
	i32 4274623895, ; 659: CommunityToolkit.Mvvm.dll => 0xfec99597 => 175
	i32 4274976490, ; 660: System.Runtime.Numerics => 0xfecef6ea => 110
	i32 4292120959, ; 661: Xamarin.AndroidX.Lifecycle.ViewModelSavedState => 0xffd4917f => 256
	i32 4292200793, ; 662: MediatR.dll => 0xffd5c959 => 177
	i32 4294763496 ; 663: Xamarin.AndroidX.ExifInterface.dll => 0xfffce3e8 => 242
], align 4

@assembly_image_cache_indices = dso_local local_unnamed_addr constant [664 x i32] [
	i32 68, ; 0
	i32 67, ; 1
	i32 108, ; 2
	i32 192, ; 3
	i32 252, ; 4
	i32 286, ; 5
	i32 48, ; 6
	i32 294, ; 7
	i32 80, ; 8
	i32 303, ; 9
	i32 145, ; 10
	i32 30, ; 11
	i32 327, ; 12
	i32 124, ; 13
	i32 206, ; 14
	i32 102, ; 15
	i32 311, ; 16
	i32 270, ; 17
	i32 107, ; 18
	i32 270, ; 19
	i32 139, ; 20
	i32 290, ; 21
	i32 326, ; 22
	i32 319, ; 23
	i32 77, ; 24
	i32 124, ; 25
	i32 13, ; 26
	i32 226, ; 27
	i32 132, ; 28
	i32 272, ; 29
	i32 151, ; 30
	i32 18, ; 31
	i32 224, ; 32
	i32 26, ; 33
	i32 246, ; 34
	i32 1, ; 35
	i32 59, ; 36
	i32 42, ; 37
	i32 91, ; 38
	i32 229, ; 39
	i32 147, ; 40
	i32 248, ; 41
	i32 245, ; 42
	i32 54, ; 43
	i32 69, ; 44
	i32 324, ; 45
	i32 215, ; 46
	i32 83, ; 47
	i32 302, ; 48
	i32 247, ; 49
	i32 209, ; 50
	i32 131, ; 51
	i32 55, ; 52
	i32 149, ; 53
	i32 74, ; 54
	i32 145, ; 55
	i32 62, ; 56
	i32 146, ; 57
	i32 331, ; 58
	i32 165, ; 59
	i32 178, ; 60
	i32 322, ; 61
	i32 230, ; 62
	i32 12, ; 63
	i32 243, ; 64
	i32 125, ; 65
	i32 152, ; 66
	i32 328, ; 67
	i32 113, ; 68
	i32 166, ; 69
	i32 164, ; 70
	i32 245, ; 71
	i32 258, ; 72
	i32 300, ; 73
	i32 84, ; 74
	i32 200, ; 75
	i32 150, ; 76
	i32 290, ; 77
	i32 60, ; 78
	i32 321, ; 79
	i32 196, ; 80
	i32 51, ; 81
	i32 103, ; 82
	i32 114, ; 83
	i32 40, ; 84
	i32 283, ; 85
	i32 281, ; 86
	i32 120, ; 87
	i32 173, ; 88
	i32 52, ; 89
	i32 44, ; 90
	i32 119, ; 91
	i32 235, ; 92
	i32 313, ; 93
	i32 241, ; 94
	i32 81, ; 95
	i32 0, ; 96
	i32 136, ; 97
	i32 277, ; 98
	i32 222, ; 99
	i32 8, ; 100
	i32 73, ; 101
	i32 155, ; 102
	i32 292, ; 103
	i32 154, ; 104
	i32 92, ; 105
	i32 287, ; 106
	i32 45, ; 107
	i32 291, ; 108
	i32 109, ; 109
	i32 129, ; 110
	i32 207, ; 111
	i32 25, ; 112
	i32 212, ; 113
	i32 72, ; 114
	i32 55, ; 115
	i32 46, ; 116
	i32 319, ; 117
	i32 199, ; 118
	i32 236, ; 119
	i32 22, ; 120
	i32 250, ; 121
	i32 86, ; 122
	i32 43, ; 123
	i32 160, ; 124
	i32 71, ; 125
	i32 263, ; 126
	i32 304, ; 127
	i32 3, ; 128
	i32 42, ; 129
	i32 63, ; 130
	i32 318, ; 131
	i32 16, ; 132
	i32 53, ; 133
	i32 315, ; 134
	i32 286, ; 135
	i32 105, ; 136
	i32 291, ; 137
	i32 308, ; 138
	i32 284, ; 139
	i32 247, ; 140
	i32 34, ; 141
	i32 158, ; 142
	i32 85, ; 143
	i32 32, ; 144
	i32 317, ; 145
	i32 12, ; 146
	i32 51, ; 147
	i32 195, ; 148
	i32 56, ; 149
	i32 267, ; 150
	i32 36, ; 151
	i32 191, ; 152
	i32 285, ; 153
	i32 220, ; 154
	i32 35, ; 155
	i32 298, ; 156
	i32 58, ; 157
	i32 329, ; 158
	i32 254, ; 159
	i32 176, ; 160
	i32 17, ; 161
	i32 288, ; 162
	i32 164, ; 163
	i32 188, ; 164
	i32 320, ; 165
	i32 314, ; 166
	i32 310, ; 167
	i32 253, ; 168
	i32 198, ; 169
	i32 280, ; 170
	i32 181, ; 171
	i32 316, ; 172
	i32 153, ; 173
	i32 193, ; 174
	i32 276, ; 175
	i32 261, ; 176
	i32 181, ; 177
	i32 222, ; 178
	i32 185, ; 179
	i32 29, ; 180
	i32 175, ; 181
	i32 52, ; 182
	i32 281, ; 183
	i32 5, ; 184
	i32 296, ; 185
	i32 271, ; 186
	i32 275, ; 187
	i32 227, ; 188
	i32 292, ; 189
	i32 219, ; 190
	i32 208, ; 191
	i32 238, ; 192
	i32 305, ; 193
	i32 85, ; 194
	i32 280, ; 195
	i32 61, ; 196
	i32 112, ; 197
	i32 325, ; 198
	i32 57, ; 199
	i32 326, ; 200
	i32 267, ; 201
	i32 99, ; 202
	i32 19, ; 203
	i32 231, ; 204
	i32 111, ; 205
	i32 101, ; 206
	i32 102, ; 207
	i32 294, ; 208
	i32 104, ; 209
	i32 284, ; 210
	i32 71, ; 211
	i32 38, ; 212
	i32 32, ; 213
	i32 103, ; 214
	i32 73, ; 215
	i32 300, ; 216
	i32 9, ; 217
	i32 123, ; 218
	i32 46, ; 219
	i32 221, ; 220
	i32 200, ; 221
	i32 9, ; 222
	i32 43, ; 223
	i32 4, ; 224
	i32 268, ; 225
	i32 179, ; 226
	i32 195, ; 227
	i32 324, ; 228
	i32 31, ; 229
	i32 330, ; 230
	i32 138, ; 231
	i32 92, ; 232
	i32 93, ; 233
	i32 330, ; 234
	i32 49, ; 235
	i32 141, ; 236
	i32 112, ; 237
	i32 140, ; 238
	i32 237, ; 239
	i32 115, ; 240
	i32 285, ; 241
	i32 157, ; 242
	i32 76, ; 243
	i32 79, ; 244
	i32 257, ; 245
	i32 37, ; 246
	i32 279, ; 247
	i32 189, ; 248
	i32 174, ; 249
	i32 241, ; 250
	i32 234, ; 251
	i32 64, ; 252
	i32 138, ; 253
	i32 15, ; 254
	i32 116, ; 255
	i32 273, ; 256
	i32 282, ; 257
	i32 229, ; 258
	i32 48, ; 259
	i32 70, ; 260
	i32 80, ; 261
	i32 126, ; 262
	i32 179, ; 263
	i32 180, ; 264
	i32 94, ; 265
	i32 121, ; 266
	i32 289, ; 267
	i32 26, ; 268
	i32 209, ; 269
	i32 250, ; 270
	i32 97, ; 271
	i32 28, ; 272
	i32 225, ; 273
	i32 295, ; 274
	i32 149, ; 275
	i32 169, ; 276
	i32 4, ; 277
	i32 98, ; 278
	i32 33, ; 279
	i32 93, ; 280
	i32 272, ; 281
	i32 196, ; 282
	i32 21, ; 283
	i32 41, ; 284
	i32 170, ; 285
	i32 311, ; 286
	i32 243, ; 287
	i32 303, ; 288
	i32 257, ; 289
	i32 288, ; 290
	i32 282, ; 291
	i32 262, ; 292
	i32 2, ; 293
	i32 134, ; 294
	i32 111, ; 295
	i32 197, ; 296
	i32 212, ; 297
	i32 320, ; 298
	i32 58, ; 299
	i32 95, ; 300
	i32 302, ; 301
	i32 39, ; 302
	i32 223, ; 303
	i32 183, ; 304
	i32 25, ; 305
	i32 94, ; 306
	i32 296, ; 307
	i32 89, ; 308
	i32 99, ; 309
	i32 10, ; 310
	i32 87, ; 311
	i32 307, ; 312
	i32 100, ; 313
	i32 269, ; 314
	i32 186, ; 315
	i32 289, ; 316
	i32 214, ; 317
	i32 299, ; 318
	i32 7, ; 319
	i32 183, ; 320
	i32 254, ; 321
	i32 211, ; 322
	i32 88, ; 323
	i32 249, ; 324
	i32 154, ; 325
	i32 298, ; 326
	i32 33, ; 327
	i32 194, ; 328
	i32 116, ; 329
	i32 82, ; 330
	i32 210, ; 331
	i32 20, ; 332
	i32 11, ; 333
	i32 162, ; 334
	i32 3, ; 335
	i32 204, ; 336
	i32 306, ; 337
	i32 0, ; 338
	i32 199, ; 339
	i32 197, ; 340
	i32 84, ; 341
	i32 192, ; 342
	i32 293, ; 343
	i32 64, ; 344
	i32 308, ; 345
	i32 276, ; 346
	i32 143, ; 347
	i32 258, ; 348
	i32 157, ; 349
	i32 180, ; 350
	i32 41, ; 351
	i32 117, ; 352
	i32 187, ; 353
	i32 213, ; 354
	i32 265, ; 355
	i32 131, ; 356
	i32 75, ; 357
	i32 66, ; 358
	i32 312, ; 359
	i32 172, ; 360
	i32 217, ; 361
	i32 143, ; 362
	i32 106, ; 363
	i32 151, ; 364
	i32 70, ; 365
	i32 328, ; 366
	i32 306, ; 367
	i32 156, ; 368
	i32 186, ; 369
	i32 121, ; 370
	i32 127, ; 371
	i32 307, ; 372
	i32 329, ; 373
	i32 152, ; 374
	i32 240, ; 375
	i32 141, ; 376
	i32 227, ; 377
	i32 304, ; 378
	i32 20, ; 379
	i32 14, ; 380
	i32 135, ; 381
	i32 75, ; 382
	i32 59, ; 383
	i32 207, ; 384
	i32 230, ; 385
	i32 167, ; 386
	i32 168, ; 387
	i32 202, ; 388
	i32 15, ; 389
	i32 74, ; 390
	i32 6, ; 391
	i32 23, ; 392
	i32 310, ; 393
	i32 252, ; 394
	i32 211, ; 395
	i32 91, ; 396
	i32 305, ; 397
	i32 1, ; 398
	i32 136, ; 399
	i32 309, ; 400
	i32 253, ; 401
	i32 275, ; 402
	i32 134, ; 403
	i32 69, ; 404
	i32 146, ; 405
	i32 193, ; 406
	i32 314, ; 407
	i32 293, ; 408
	i32 244, ; 409
	i32 177, ; 410
	i32 198, ; 411
	i32 88, ; 412
	i32 96, ; 413
	i32 234, ; 414
	i32 239, ; 415
	i32 309, ; 416
	i32 31, ; 417
	i32 45, ; 418
	i32 248, ; 419
	i32 182, ; 420
	i32 213, ; 421
	i32 109, ; 422
	i32 158, ; 423
	i32 35, ; 424
	i32 22, ; 425
	i32 178, ; 426
	i32 114, ; 427
	i32 57, ; 428
	i32 273, ; 429
	i32 144, ; 430
	i32 118, ; 431
	i32 120, ; 432
	i32 110, ; 433
	i32 215, ; 434
	i32 139, ; 435
	i32 221, ; 436
	i32 295, ; 437
	i32 54, ; 438
	i32 105, ; 439
	i32 315, ; 440
	i32 203, ; 441
	i32 204, ; 442
	i32 133, ; 443
	i32 287, ; 444
	i32 278, ; 445
	i32 266, ; 446
	i32 321, ; 447
	i32 244, ; 448
	i32 206, ; 449
	i32 159, ; 450
	i32 231, ; 451
	i32 163, ; 452
	i32 132, ; 453
	i32 266, ; 454
	i32 161, ; 455
	i32 255, ; 456
	i32 182, ; 457
	i32 140, ; 458
	i32 278, ; 459
	i32 274, ; 460
	i32 169, ; 461
	i32 205, ; 462
	i32 174, ; 463
	i32 216, ; 464
	i32 283, ; 465
	i32 40, ; 466
	i32 242, ; 467
	i32 81, ; 468
	i32 56, ; 469
	i32 37, ; 470
	i32 97, ; 471
	i32 166, ; 472
	i32 172, ; 473
	i32 194, ; 474
	i32 279, ; 475
	i32 82, ; 476
	i32 218, ; 477
	i32 98, ; 478
	i32 30, ; 479
	i32 159, ; 480
	i32 18, ; 481
	i32 127, ; 482
	i32 119, ; 483
	i32 238, ; 484
	i32 269, ; 485
	i32 251, ; 486
	i32 271, ; 487
	i32 165, ; 488
	i32 246, ; 489
	i32 331, ; 490
	i32 301, ; 491
	i32 268, ; 492
	i32 259, ; 493
	i32 170, ; 494
	i32 16, ; 495
	i32 184, ; 496
	i32 144, ; 497
	i32 125, ; 498
	i32 118, ; 499
	i32 38, ; 500
	i32 115, ; 501
	i32 47, ; 502
	i32 142, ; 503
	i32 117, ; 504
	i32 34, ; 505
	i32 176, ; 506
	i32 95, ; 507
	i32 53, ; 508
	i32 260, ; 509
	i32 129, ; 510
	i32 153, ; 511
	i32 184, ; 512
	i32 24, ; 513
	i32 161, ; 514
	i32 237, ; 515
	i32 148, ; 516
	i32 104, ; 517
	i32 89, ; 518
	i32 225, ; 519
	i32 60, ; 520
	i32 142, ; 521
	i32 100, ; 522
	i32 5, ; 523
	i32 13, ; 524
	i32 122, ; 525
	i32 135, ; 526
	i32 28, ; 527
	i32 301, ; 528
	i32 72, ; 529
	i32 235, ; 530
	i32 24, ; 531
	i32 223, ; 532
	i32 264, ; 533
	i32 261, ; 534
	i32 318, ; 535
	i32 137, ; 536
	i32 208, ; 537
	i32 216, ; 538
	i32 232, ; 539
	i32 168, ; 540
	i32 265, ; 541
	i32 297, ; 542
	i32 101, ; 543
	i32 123, ; 544
	i32 236, ; 545
	i32 190, ; 546
	i32 163, ; 547
	i32 167, ; 548
	i32 239, ; 549
	i32 39, ; 550
	i32 201, ; 551
	i32 316, ; 552
	i32 17, ; 553
	i32 171, ; 554
	i32 317, ; 555
	i32 137, ; 556
	i32 150, ; 557
	i32 228, ; 558
	i32 155, ; 559
	i32 130, ; 560
	i32 19, ; 561
	i32 65, ; 562
	i32 147, ; 563
	i32 47, ; 564
	i32 325, ; 565
	i32 327, ; 566
	i32 214, ; 567
	i32 79, ; 568
	i32 61, ; 569
	i32 106, ; 570
	i32 263, ; 571
	i32 218, ; 572
	i32 49, ; 573
	i32 249, ; 574
	i32 322, ; 575
	i32 260, ; 576
	i32 14, ; 577
	i32 187, ; 578
	i32 68, ; 579
	i32 171, ; 580
	i32 224, ; 581
	i32 228, ; 582
	i32 78, ; 583
	i32 233, ; 584
	i32 108, ; 585
	i32 217, ; 586
	i32 189, ; 587
	i32 259, ; 588
	i32 67, ; 589
	i32 63, ; 590
	i32 27, ; 591
	i32 160, ; 592
	i32 297, ; 593
	i32 210, ; 594
	i32 188, ; 595
	i32 226, ; 596
	i32 10, ; 597
	i32 201, ; 598
	i32 11, ; 599
	i32 173, ; 600
	i32 78, ; 601
	i32 126, ; 602
	i32 83, ; 603
	i32 191, ; 604
	i32 66, ; 605
	i32 107, ; 606
	i32 65, ; 607
	i32 128, ; 608
	i32 122, ; 609
	i32 77, ; 610
	i32 274, ; 611
	i32 264, ; 612
	i32 8, ; 613
	i32 232, ; 614
	i32 2, ; 615
	i32 313, ; 616
	i32 44, ; 617
	i32 277, ; 618
	i32 156, ; 619
	i32 128, ; 620
	i32 262, ; 621
	i32 23, ; 622
	i32 133, ; 623
	i32 220, ; 624
	i32 251, ; 625
	i32 29, ; 626
	i32 219, ; 627
	i32 62, ; 628
	i32 203, ; 629
	i32 90, ; 630
	i32 87, ; 631
	i32 148, ; 632
	i32 299, ; 633
	i32 205, ; 634
	i32 36, ; 635
	i32 86, ; 636
	i32 240, ; 637
	i32 185, ; 638
	i32 323, ; 639
	i32 190, ; 640
	i32 50, ; 641
	i32 6, ; 642
	i32 90, ; 643
	i32 323, ; 644
	i32 21, ; 645
	i32 162, ; 646
	i32 96, ; 647
	i32 50, ; 648
	i32 113, ; 649
	i32 256, ; 650
	i32 130, ; 651
	i32 76, ; 652
	i32 27, ; 653
	i32 312, ; 654
	i32 233, ; 655
	i32 255, ; 656
	i32 7, ; 657
	i32 202, ; 658
	i32 175, ; 659
	i32 110, ; 660
	i32 256, ; 661
	i32 177, ; 662
	i32 242 ; 663
], align 4

@marshal_methods_number_of_classes = dso_local local_unnamed_addr constant i32 0, align 4

@marshal_methods_class_cache = dso_local local_unnamed_addr global [0 x %struct.MarshalMethodsManagedClass] zeroinitializer, align 4

; Names of classes in which marshal methods reside
@mm_class_names = dso_local local_unnamed_addr constant [0 x ptr] zeroinitializer, align 4

@mm_method_names = dso_local local_unnamed_addr constant [1 x %struct.MarshalMethodName] [
	%struct.MarshalMethodName {
		i64 0, ; id 0x0; name: 
		ptr @.MarshalMethodName.0_name; char* name
	} ; 0
], align 8

; get_function_pointer (uint32_t mono_image_index, uint32_t class_index, uint32_t method_token, void*& target_ptr)
@get_function_pointer = internal dso_local unnamed_addr global ptr null, align 4

; Functions

; Function attributes: "min-legal-vector-width"="0" mustprogress nofree norecurse nosync "no-trapping-math"="true" nounwind "stack-protector-buffer-size"="8" uwtable willreturn
define void @xamarin_app_init(ptr nocapture noundef readnone %env, ptr noundef %fn) local_unnamed_addr #0
{
	%fnIsNull = icmp eq ptr %fn, null
	br i1 %fnIsNull, label %1, label %2

1: ; preds = %0
	%putsResult = call noundef i32 @puts(ptr @.str.0)
	call void @abort()
	unreachable 

2: ; preds = %1, %0
	store ptr %fn, ptr @get_function_pointer, align 4, !tbaa !3
	ret void
}

; Strings
@.str.0 = private unnamed_addr constant [40 x i8] c"get_function_pointer MUST be specified\0A\00", align 1

;MarshalMethodName
@.MarshalMethodName.0_name = private unnamed_addr constant [1 x i8] c"\00", align 1

; External functions

; Function attributes: noreturn "no-trapping-math"="true" nounwind "stack-protector-buffer-size"="8"
declare void @abort() local_unnamed_addr #2

; Function attributes: nofree nounwind
declare noundef i32 @puts(ptr noundef) local_unnamed_addr #1
attributes #0 = { "min-legal-vector-width"="0" mustprogress nofree norecurse nosync "no-trapping-math"="true" nounwind "stack-protector-buffer-size"="8" "stackrealign" "target-cpu"="i686" "target-features"="+cx8,+mmx,+sse,+sse2,+sse3,+ssse3,+x87" "tune-cpu"="generic" uwtable willreturn }
attributes #1 = { nofree nounwind }
attributes #2 = { noreturn "no-trapping-math"="true" nounwind "stack-protector-buffer-size"="8" "stackrealign" "target-cpu"="i686" "target-features"="+cx8,+mmx,+sse,+sse2,+sse3,+ssse3,+x87" "tune-cpu"="generic" }

; Metadata
!llvm.module.flags = !{!0, !1, !7}
!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!llvm.ident = !{!2}
!2 = !{!"Xamarin.Android remotes/origin/release/8.0.1xx @ f1b7113872c8db3dfee70d11925e81bb752dc8d0"}
!3 = !{!4, !4, i64 0}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{i32 1, !"NumRegisterParameters", i32 0}
