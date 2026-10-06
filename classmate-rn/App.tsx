import React, { useState } from "react";
import { Pressable, SafeAreaView, ScrollView, StatusBar, StyleSheet, Text, View } from "react-native";

const C = { bg:"#080A10", panel:"#11141D", panel2:"#151925", border:"#252B3A", text:"#F5F7FB", muted:"#8D95A8", cyan:"#63E6FF", purple:"#9B7CFF", green:"#65E6A5", orange:"#FFB86B" };
const days = [["sat","ش","۱۲"],["sun","ی","۱۳"],["mon","د","۱۴"],["tue","س","۱۵"],["wed","چ","۱۶"],["thu","پ","۱۷"],["fri","ج","۱۸"]];
const classes = [
  ["ساختمان داده","دکتر احمدی","۱۰:۳۰","کلاس ۲۰۴",C.cyan,"⌘"],
  ["سیستم عامل","مهندس رضایی","۱۳:۰۰","لابراتوار ۱",C.purple,"◈"],
  ["مهندسی نرم‌افزار","دکتر کریمی","۱۵:۳۰","کلاس ۱۰۷",C.green,"◉"]
];
const tasks = [
  ["تحویل پروژه ساختمان داده","۲ روز مانده","پروژه",C.cyan],
  ["امتحان میان‌ترم سیستم عامل","۵ روز مانده","امتحان",C.orange],
  ["گزارش مهندسی نرم‌افزار","۷ روز مانده","تکلیف",C.purple]
];

export default function App() {
  const [tab,setTab] = useState("home");
  const [day,setDay] = useState("tue");
  const [done,setDone] = useState<number[]>([2]);

  const toggle = (i:number) => setDone(v => v.includes(i) ? v.filter(x=>x!==i) : [...v,i]);

  return <SafeAreaView style={s.safe}>
    <StatusBar barStyle="light-content"/>
    <View style={s.app}>
      <ScrollView contentContainerStyle={s.content} showsVerticalScrollIndicator={false}>
        {tab==="home" && <>
          <Header/>
          <Days selected={day} onSelect={setDay}/>
          <NextClass/>
          <Section title="برنامه امروز" action="مشاهده همه"/>
          <Timeline/>
          <Section title="کارهای نزدیک" action="همه کارها"/>
          <ScrollView horizontal inverted showsHorizontalScrollIndicator={false} contentContainerStyle={s.row}>
            {tasks.map((t,i)=><Pressable key={i} onPress={()=>toggle(i)} style={[s.task,done.includes(i)&&s.done]}>
              <View style={s.taskTop}><Text style={[s.badge,{color:t[3],backgroundColor:t[3]+"18"}]}>{t[2]}</Text><Text style={s.check}>{done.includes(i)?"✓":"○"}</Text></View>
              <Text style={[s.taskTitle,done.includes(i)&&s.strike]}>{t[0]}</Text><Text style={s.meta}>{t[1]}</Text>
            </Pressable>)}
          </ScrollView>
          <Goal/><Motivation/>
        </>}
        {tab==="schedule" && <Schedule/>}
        {tab==="tasks" && <Tasks done={done} toggle={toggle}/>}
        {tab==="stats" && <Stats/>}
      </ScrollView>
      <Nav tab={tab} setTab={setTab}/>
    </View>
  </SafeAreaView>;
}

function Header(){return <View style={s.header}>
  <View><Text style={s.eyebrow}>امروز • سه‌شنبه ۱۵ مهر</Text><Text style={s.greeting}>سلام، دانشجو 👋</Text></View>
  <View style={s.bell}><Text style={s.bellText}>♢</Text><View style={s.dot}/></View>
</View>}

function Days({selected,onSelect}:{selected:string,onSelect:(x:string)=>void}){return <ScrollView horizontal inverted showsHorizontalScrollIndicator={false} contentContainerStyle={s.days}>
  {days.map(d=><Pressable key={d[0]} onPress={()=>onSelect(d[0])} style={[s.day,d[0]===selected&&s.dayActive]}>
    <Text style={[s.dayLabel,d[0]===selected&&s.activeText]}>{d[1]}</Text><Text style={[s.dayDate,d[0]===selected&&s.activeText]}>{d[2]}</Text>
  </Pressable>)}
</ScrollView>}

function NextClass(){return <View style={s.next}>
  <View style={s.nextHead}><View><Text style={s.cyanText}>کلاس بعدی</Text><Text style={s.nextTitle}>ساختمان داده</Text><Text style={s.meta}>دکتر احمدی  •  کلاس ۲۰۴</Text></View><View style={s.bigIcon}><Text style={s.bigIconText}>⌘</Text></View></View>
  <View style={s.nextBottom}><View><Text style={s.bigTime}>۱۰:۳۰</Text><Text style={s.meta}>امروز</Text></View><View><Text style={s.count}>۴۲</Text><Text style={s.meta}>دقیقه تا شروع</Text></View></View>
</View>}

function Section({title,action}:{title:string,action:string}){return <View style={s.section}><Text style={s.sectionTitle}>{title}</Text><Text style={s.action}>{action}</Text></View>}

function Timeline(){return <View style={s.timeline}>{classes.map((c,i)=><View key={i} style={s.trow}>
  <Text style={s.time}>{c[2]}</Text><View style={s.lineCol}><View style={[s.tdot,{backgroundColor:c[4] as string}]}/>{i<2&&<View style={s.line}/>}</View>
  <View style={s.classItem}><View style={[s.mini,{borderColor:(c[4] as string)+"55"}]}><Text style={[s.miniText,{color:c[4] as string}]}>{c[5]}</Text></View><View style={s.classInfo}><Text style={s.classTitle}>{c[0]}</Text><Text style={s.meta}>{c[1]}  •  {c[3]}</Text></View></View>
</View>)}</View>}

function Goal(){return <View style={s.card}><View style={s.goalHead}><View><Text style={s.classTitle}>هدف هفتگی</Text><Text style={s.meta}>۴ از ۵ روز مطالعه انجام شد</Text></View><Text style={s.percent}>۷۸٪</Text></View><View style={s.track}><View style={s.fill}/></View><Text style={s.meta}>فقط یک قدم تا هدف این هفته باقی مانده 🚀</Text></View>}

function Motivation(){return <View style={s.motivation}><Text style={s.quote}>“</Text><Text style={s.motText}>پیشرفت‌های کوچک، نتیجه‌های بزرگ می‌سازند.</Text><Text style={s.meta}>امروز فقط روی قدم بعدی تمرکز کن.</Text></View>}

function PageTitle({title,sub}:{title:string,sub:string}){return <View style={s.pageTitle}><Text style={s.pageTitleText}>{title}</Text><Text style={s.meta}>{sub}</Text></View>}

function Schedule(){return <><PageTitle title="برنامه هفتگی" sub="همه کلاس‌ها در یک نگاه"/><Days selected="tue" onSelect={()=>{}}/><View style={s.card}>{[...classes,["آزمایشگاه شبکه","دکتر موسوی","۱۷:۰۰","لاب ۳",C.orange,"⌁"]].map((c,i)=><View style={s.scheduleRow} key={i}><Text style={s.time}>{c[2]}</Text><View style={[s.scheduleBar,{backgroundColor:c[4] as string}]}/><View style={s.classInfo}><Text style={s.classTitle}>{c[0]}</Text><Text style={s.meta}>{c[1]}  •  {c[3]}</Text></View></View>)}</View></>}

function Tasks({done,toggle}:{done:number[],toggle:(i:number)=>void}){return <><PageTitle title="کارها و امتحان‌ها" sub="موعدهای مهمت را از دست نده"/><View style={s.card}>{tasks.map((t,i)=><Pressable key={i} onPress={()=>toggle(i)} style={s.fullTask}><View style={[s.fullCheck,done.includes(i)&&s.fullCheckDone]}><Text>{done.includes(i)?"✓":""}</Text></View><View style={s.classInfo}><Text style={[s.classTitle,done.includes(i)&&s.strike]}>{t[0]}</Text><Text style={s.meta}>{t[2]}  •  {t[1]}</Text></View></Pressable>)}</View><View style={s.add}><Text style={s.addText}>＋ افزودن کار جدید</Text></View></>}

function Stats(){return <><PageTitle title="آمار من" sub="تصویر ساده‌ای از عملکرد این هفته"/><View style={s.stats}>{[["حضور","۸۷٪","این ترم"],["کارهای انجام‌شده","۱۲","از ۱۵"],["مطالعه","۱۸h","این هفته"],["پشت‌سرهم","۴","روز"]].map((x,i)=><View style={s.stat} key={i}><Text style={s.meta}>{x[0]}</Text><Text style={s.statValue}>{x[1]}</Text><Text style={s.meta}>{x[2]}</Text></View>)}</View><View style={s.card}><Text style={s.sectionTitle}>روند هفتگی</Text><View style={s.bars}>{[45,68,52,82,74,92,60].map((h,i)=><View style={s.barItem} key={i}><View style={[s.bar,{height:h}]}/><Text style={s.meta}>{days[i][1]}</Text></View>)}</View></View></>}

function Nav({tab,setTab}:{tab:string,setTab:(x:string)=>void}){const items=[["home","⌂","خانه"],["schedule","▦","برنامه"],["tasks","✓","کارها"],["stats","◒","آمار"]];return <View style={s.nav}>{items.map(x=><Pressable key={x[0]} onPress={()=>setTab(x[0])} style={s.navItem}><View style={[s.navIcon,tab===x[0]&&s.navIconActive]}><Text style={[s.navIconText,tab===x[0]&&s.cyan]}>{x[1]}</Text></View><Text style={[s.navLabel,tab===x[0]&&s.cyan]}>{x[2]}</Text></Pressable>)}</View>}

const s=StyleSheet.create({
 safe:{flex:1,backgroundColor:C.bg},app:{flex:1,backgroundColor:C.bg},content:{padding:18,paddingBottom:115},
 header:{flexDirection:"row-reverse",justifyContent:"space-between",alignItems:"center",marginBottom:20},eyebrow:{color:C.muted,fontSize:12,textAlign:"right"},greeting:{color:C.text,fontSize:25,fontWeight:"800",textAlign:"right",marginTop:4},
 bell:{width:44,height:44,borderRadius:15,backgroundColor:C.panel,borderWidth:1,borderColor:C.border,alignItems:"center",justifyContent:"center",position:"relative"},bellText:{color:C.text,fontSize:25},dot:{position:"absolute",top:9,right:10,width:7,height:7,borderRadius:4,backgroundColor:C.cyan},
 days:{flexDirection:"row",gap:9,paddingBottom:18},day:{width:48,height:64,borderRadius:16,backgroundColor:C.panel,borderWidth:1,borderColor:C.border,alignItems:"center",justifyContent:"center"},dayActive:{backgroundColor:C.cyan,borderColor:C.cyan},dayLabel:{color:C.muted,fontSize:12,fontWeight:"700",marginBottom:5},dayDate:{color:C.text,fontSize:17,fontWeight:"800"},activeText:{color:C.bg},
 next:{backgroundColor:C.panel2,borderRadius:24,padding:20,borderWidth:1,borderColor:"#293044",marginBottom:24},nextHead:{flexDirection:"row-reverse",justifyContent:"space-between"},cyanText:{color:C.cyan,fontSize:12,fontWeight:"700",textAlign:"right",marginBottom:7},nextTitle:{color:C.text,fontSize:22,fontWeight:"800",textAlign:"right",marginBottom:6},bigIcon:{width:48,height:48,borderRadius:16,backgroundColor:"#63E6FF15",borderWidth:1,borderColor:"#63E6FF35",alignItems:"center",justifyContent:"center"},bigIconText:{color:C.cyan,fontSize:25,fontWeight:"800"},nextBottom:{flexDirection:"row-reverse",justifyContent:"space-between",alignItems:"flex-end",marginTop:22},bigTime:{color:C.text,fontSize:25,fontWeight:"900",textAlign:"right"},count:{color:C.cyan,fontSize:30,fontWeight:"900"},
 section:{flexDirection:"row-reverse",justifyContent:"space-between",alignItems:"center",marginBottom:12},sectionTitle:{color:C.text,fontSize:16,fontWeight:"800",textAlign:"right"},action:{color:C.cyan,fontSize:11,fontWeight:"700"},timeline:{marginBottom:22},trow:{flexDirection:"row-reverse",minHeight:72},time:{width:55,color:C.muted,fontSize:11,fontWeight:"700",textAlign:"right"},lineCol:{width:22,alignItems:"center"},tdot:{width:10,height:10,borderRadius:5,marginTop:4},line:{width:1,flex:1,backgroundColor:C.border,marginTop:4},classItem:{flex:1,flexDirection:"row-reverse",gap:10,paddingBottom:13},mini:{width:36,height:36,borderRadius:12,backgroundColor:C.panel,borderWidth:1,alignItems:"center",justifyContent:"center"},miniText:{fontSize:16,fontWeight:"900"},classInfo:{flex:1},classTitle:{color:C.text,fontSize:14,fontWeight:"800",textAlign:"right"},meta:{color:C.muted,fontSize:11,textAlign:"right",marginTop:4},
 row:{flexDirection:"row",gap:10,paddingBottom:22},task:{width:185,minHeight:118,borderRadius:19,padding:15,backgroundColor:C.panel,borderWidth:1,borderColor:C.border},done:{opacity:.58},taskTop:{flexDirection:"row-reverse",justifyContent:"space-between",alignItems:"center",marginBottom:12},badge:{paddingHorizontal:8,paddingVertical:4,borderRadius:8,fontSize:9,fontWeight:"800"},check:{color:C.muted,fontSize:19},taskTitle:{color:C.text,fontSize:12,lineHeight:19,fontWeight:"700",textAlign:"right"},strike:{textDecorationLine:"line-through"},
 card:{backgroundColor:C.panel,borderRadius:20,borderWidth:1,borderColor:C.border,padding:16,marginBottom:16},goalHead:{flexDirection:"row-reverse",justifyContent:"space-between",alignItems:"center"},percent:{color:C.green,fontSize:20,fontWeight:"900"},track:{height:7,backgroundColor:C.border,borderRadius:4,overflow:"hidden",marginTop:14,marginBottom:8},fill:{height:"100%",width:"78%",backgroundColor:C.green},motivation:{padding:20,borderRadius:20,backgroundColor:"#9B7CFF12",borderWidth:1,borderColor:"#9B7CFF25"},quote:{color:C.purple,fontSize:35,textAlign:"right"},motText:{color:C.text,fontSize:15,fontWeight:"800",textAlign:"right",lineHeight:24},
 pageTitle:{alignItems:"flex-end",marginBottom:22},pageTitleText:{color:C.text,fontSize:26,fontWeight:"900",textAlign:"right",marginBottom:5},scheduleRow:{flexDirection:"row-reverse",alignItems:"center",minHeight:72,borderBottomWidth:1,borderBottomColor:C.border},scheduleBar:{width:3,height:42,borderRadius:2,marginHorizontal:12},fullTask:{flexDirection:"row-reverse",alignItems:"center",gap:12,paddingVertical:14,borderBottomWidth:1,borderBottomColor:C.border},fullCheck:{width:26,height:26,borderRadius:9,borderWidth:1,borderColor:C.border,alignItems:"center",justifyContent:"center"},fullCheckDone:{backgroundColor:C.green,borderColor:C.green},add:{backgroundColor:C.cyan,borderRadius:16,padding:16,alignItems:"center"},addText:{color:C.bg,fontSize:13,fontWeight:"900"},
 stats:{flexDirection:"row-reverse",flexWrap:"wrap",gap:10,marginBottom:16},stat:{width:"48%",backgroundColor:C.panel,borderWidth:1,borderColor:C.border,borderRadius:18,padding:15,minHeight:110},statValue:{color:C.text,fontSize:25,fontWeight:"900",textAlign:"right",marginVertical:10},bars:{height:150,flexDirection:"row",alignItems:"flex-end",justifyContent:"space-around",marginTop:20},barItem:{alignItems:"center",justifyContent:"flex-end",height:"100%"},bar:{width:20,borderRadius:8,backgroundColor:C.cyan,opacity:.8},
 nav:{position:"absolute",left:12,right:12,bottom:12,height:72,borderRadius:24,backgroundColor:"#11141DED",borderWidth:1,borderColor:C.border,flexDirection:"row-reverse",justifyContent:"space-around",alignItems:"center"},navItem:{alignItems:"center",width:"25%"},navIcon:{width:35,height:32,alignItems:"center",justifyContent:"center",borderRadius:11},navIconActive:{backgroundColor:"#63E6FF18"},navIconText:{color:C.muted,fontSize:18,fontWeight:"800"},navLabel:{color:C.muted,fontSize:9,marginTop:3,fontWeight:"700"},cyan:{color:C.cyan}
});