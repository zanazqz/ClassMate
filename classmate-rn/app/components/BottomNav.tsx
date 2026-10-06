import React from "react";
import { Pressable, Text, View } from "react-native";
import { C } from "../theme/theme";
import { styles } from "./styles";

const items=[["home","⌂","خانه"],["schedule","▦","برنامه"],["tasks","✓","کارها"],["stats","◒","آمار"]];
export function BottomNav({tab,setTab}:{tab:string;setTab:(x:string)=>void}) {
  return <View style={styles.nav}>{items.map(x=><Pressable key={x[0]} onPress={()=>setTab(x[0])} style={styles.navItem}>
    <View style={[styles.navIcon,tab===x[0]&&styles.navIconActive]}><Text style={[styles.navIconText,tab===x[0]&&styles.cyan]}>{x[1]}</Text></View>
    <Text style={[styles.navLabel,tab===x[0]&&styles.cyan]}>{x[2]}</Text>
  </Pressable>)}</View>;
}
