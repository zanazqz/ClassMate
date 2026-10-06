import React from "react";
import { Pressable, ScrollView, Text } from "react-native";
import { C } from "../theme/theme";
import { days } from "../data/mockData";
import { styles } from "./styles";

export function Days({selected,onSelect}:{selected:string;onSelect:(x:string)=>void}) {
  return <ScrollView horizontal inverted showsHorizontalScrollIndicator={false} contentContainerStyle={styles.days}>
    {days.map(d=><Pressable key={d[0]} onPress={()=>onSelect(d[0])} style={[styles.day,d[0]===selected&&styles.dayActive]}>
      <Text style={[styles.dayLabel,d[0]===selected&&styles.activeText]}>{d[1]}</Text>
      <Text style={[styles.dayDate,d[0]===selected&&styles.activeText]}>{d[2]}</Text>
    </Pressable>)}
  </ScrollView>;
}
