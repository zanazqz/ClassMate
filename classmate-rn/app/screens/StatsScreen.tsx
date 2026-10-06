import React from "react";
import { Text, View } from "react-native";
import { PageTitle } from "../components/PageTitle";
import { days } from "../data/mockData";
import { styles } from "../components/styles";
export function StatsScreen(){return <><PageTitle title="آمار من" sub="تصویر ساده‌ای از عملکرد این هفته"/><View style={styles.stats}>{[["حضور","۸۷٪","این ترم"],["کارهای انجام‌شده","۱۲","از ۱۵"],["مطالعه","۱۸h","این هفته"],["پشت‌سرهم","۴","روز"]].map((x,i)=><View style={styles.stat} key={i}><Text style={styles.meta}>{x[0]}</Text><Text style={styles.statValue}>{x[1]}</Text><Text style={styles.meta}>{x[2]}</Text></View>)}</View><View style={styles.card}><Text style={styles.sectionTitle}>روند هفتگی</Text><View style={styles.bars}>{[45,68,52,82,74,92,60].map((h,i)=><View style={styles.barItem} key={i}><View style={[styles.bar,{height:h}]}/><Text style={styles.meta}>{days[i][1]}</Text></View>)}</View></View></>}
