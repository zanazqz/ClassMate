import React from "react";
import { Text, View } from "react-native";
import { styles } from "./styles";
export function PageTitle({title,sub}:{title:string;sub:string}) {
  return <View style={styles.pageTitle}><Text style={styles.pageTitleText}>{title}</Text><Text style={styles.meta}>{sub}</Text></View>;
}
