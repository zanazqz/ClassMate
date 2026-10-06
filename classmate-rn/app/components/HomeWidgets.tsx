import React from "react";
import { Pressable, ScrollView, Text, View } from "react-native";
import { C } from "../theme/theme";
import { classes, tasks } from "../data/mockData";
import { Section } from "./Section";
import { styles } from "./styles";

export function NextClass(){return <View style={styles.next}>
  <View style={styles.nextHead}><View><Text style={styles.cyanText}>کلاس بعدی</Text><Text style={styles.nextTitle}>ساختمان داده</Text><Text style={styles.meta}>دکتر احمدی  •  کلاس ۲۰۴</Text></View><View style={styles.bigIcon}><Text style={styles.bigIconText}>⌘</Text></View></View>
  <View style={styles.nextBottom}><View><Text style={styles.bigTime}>۱۰:۳۰</Text><Text style={styles.meta}>امروز</Text></View><View><Text style={styles.count}>۴۲</Text><Text style={styles.meta}>دقیقه تا شروع</Text></View></View>
</View>}

export function Timeline(){return <View style={styles.timeline}>{classes.map((c,i)=><View key={i} style={styles.trow}>
  <Text style={styles.time}>{c[2]}</Text><View style={styles.lineCol}><View style={[styles.tdot,{backgroundColor:c[4]}]}/>{i<2&&<View style={styles.line}/>}</View>
  <View style={styles.classItem}><View style={[styles.mini,{borderColor:c[4]+"55"}]}><Text style={[styles.miniText,{color:c[4]}]}>{c[5]}</Text></View><View style={styles.classInfo}><Text style={styles.classTitle}>{c[0]}</Text><Text style={styles.meta}>{c[1]}  •  {c[3]}</Text></View></View>
</View>)}</View>}

export function TaskStrip({done,toggle}:{done:number[];toggle:(i:number)=>void}){return <><Section title="کارهای نزدیک" action="همه کارها"/><ScrollView horizontal inverted showsHorizontalScrollIndicator={false} contentContainerStyle={styles.row}>
{tasks.map((t,i)=><Pressable key={i} onPress={()=>toggle(i)} style={[styles.task,done.includes(i)&&styles.done]}><View style={styles.taskTop}><Text style={[styles.badge,{color:t[3],backgroundColor:t[3]+"18"}]}>{t[2]}</Text><Text style={styles.check}>{done.includes(i)?"✓":"○"}</Text></View><Text style={[styles.taskTitle,done.includes(i)&&styles.strike]}>{t[0]}</Text><Text style={styles.meta}>{t[1]}</Text></Pressable>)}
</ScrollView></>}

export function Goal(){return <View style={styles.card}><View style={styles.goalHead}><View><Text style={styles.classTitle}>هدف هفتگی</Text><Text style={styles.meta}>۴ از ۵ روز مطالعه انجام شد</Text></View><Text style={styles.percent}>۷۸٪</Text></View><View style={styles.track}><View style={styles.fill}/></View><Text style={styles.meta}>فقط یک قدم تا هدف این هفته باقی مانده 🚀</Text></View>}

export function Motivation(){return <View style={styles.motivation}><Text style={styles.quote}>“</Text><Text style={styles.motText}>پیشرفت‌های کوچک، نتیجه‌های بزرگ می‌سازند.</Text><Text style={styles.meta}>امروز فقط روی قدم بعدی تمرکز کن.</Text></View>}
