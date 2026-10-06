import React from "react";
import { Pressable, Text, View } from "react-native";
import { PageTitle } from "../components/PageTitle";
import { tasks } from "../data/mockData";
import { styles } from "../components/styles";
export function TasksScreen({done,toggle}:{done:number[];toggle:(i:number)=>void}){return <><PageTitle title="کارها و امتحان‌ها" sub="موعدهای مهمت را از دست نده"/><View style={styles.card}>{tasks.map((t,i)=><Pressable key={i} onPress={()=>toggle(i)} style={styles.fullTask}><View style={[styles.fullCheck,done.includes(i)&&styles.fullCheckDone]}><Text>{done.includes(i)?"✓":""}</Text></View><View style={styles.classInfo}><Text style={[styles.classTitle,done.includes(i)&&styles.strike]}>{t[0]}</Text><Text style={styles.meta}>{t[2]}  •  {t[1]}</Text></View></Pressable>)}</View><View style={styles.add}><Text style={styles.addText}>＋ افزودن کار جدید</Text></View></>}
