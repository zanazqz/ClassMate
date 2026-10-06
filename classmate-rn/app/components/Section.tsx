import React from "react";
import { Text, View } from "react-native";
import { C } from "../theme/theme";
import { styles } from "./styles";

export function Section({title,action}:{title:string;action:string}) {
  return <View style={styles.section}><Text style={styles.sectionTitle}>{title}</Text><Text style={styles.action}>{action}</Text></View>;
}
