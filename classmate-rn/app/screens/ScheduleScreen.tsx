import React from "react";
import { Text, View } from "react-native";
import { Days } from "../components/Days";
import { PageTitle } from "../components/PageTitle";
import { classes } from "../data/mockData";
import { C } from "../theme/theme";
import { styles } from "../components/styles";

export function ScheduleScreen(){return <><PageTitle title="برنامه هفتگی" sub="همه کلاس‌ها در یک نگاه"/><Days selected="tue" onSelect={()=>{}}/>
<View style={styles.card}>{[...classes,["آزمایشگاه شبکه","دکتر موسوی","۱۷:۰۰","لاب ۳",C.orange,"⌁"]].map((c,i)=><View style={styles.scheduleRow} key={i}><Text style={styles.time}>{c[2]}</Text><View style={[styles.scheduleBar,{backgroundColor:c[4]}]}/><View style={styles.classInfo}><Text style={styles.classTitle}>{c[0]}</Text><Text style={styles.meta}>{c[1]}  •  {c[3]}</Text></View></View>)}</View></>}
