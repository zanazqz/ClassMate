import React from "react";
import { Text, View } from "react-native";
import { styles } from "./styles";

export function Header() {
  return <View style={styles.header}>
    <View><Text style={styles.eyebrow}>امروز • سه‌شنبه ۱۵ مهر</Text><Text style={styles.greeting}>سلام، دانشجو 👋</Text></View>
    <View style={styles.bell}><Text style={styles.bellText}>♢</Text><View style={styles.dot}/></View>
  </View>;
}
