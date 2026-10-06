import React, { useState } from "react";
import { SafeAreaView, ScrollView, StatusBar, View } from "react-native";
import { BottomNav } from "./app/components/BottomNav";
import { HomeScreen } from "./app/screens/HomeScreen";
import { ScheduleScreen } from "./app/screens/ScheduleScreen";
import { TasksScreen } from "./app/screens/TasksScreen";
import { StatsScreen } from "./app/screens/StatsScreen";
import { C } from "./app/theme/theme";

export default function App() {
  const [tab,setTab]=useState("home");
  const [day,setDay]=useState("tue");
  const [done,setDone]=useState<number[]>([2]);
  const toggle=(i:number)=>setDone(v=>v.includes(i)?v.filter(x=>x!==i):[...v,i]);

  return <SafeAreaView style={{flex:1,backgroundColor:C.bg}}>
    <StatusBar barStyle="light-content"/>
    <View style={{flex:1,backgroundColor:C.bg}}>
      <ScrollView contentContainerStyle={{padding:18,paddingBottom:115}} showsVerticalScrollIndicator={false}>
        {tab==="home"&&<HomeScreen day={day} setDay={setDay} done={done} toggle={toggle}/>}
        {tab==="schedule"&&<ScheduleScreen/>}
        {tab==="tasks"&&<TasksScreen done={done} toggle={toggle}/>}
        {tab==="stats"&&<StatsScreen/>}
      </ScrollView>
      <BottomNav tab={tab} setTab={setTab}/>
    </View>
  </SafeAreaView>;
}
