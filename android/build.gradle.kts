//buildscript {
//    ext.kotlin_version = '1.7.10'
//    repositories {
//        google()
//        mavenCentral()
//    }
//
//    dependencies {
//        classpath 'com.android.tools.build:gradle:7.2.0'
//        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
//    }
//}
//
//allprojects {
//    repositories {
//        google()
//        mavenCentral()
//    }
//}
//
//rootProject.buildDir = '../build'
//subprojects {
//    project.buildDir = "${rootProject.buildDir}/${project.name}"
//}
//subprojects {
//    project.evaluationDependsOn(':app')
//}
//
//tasks.register("clean", Delete) {
//    delete rootProject.layout.buildDirectory
//}

plugins {
    // ...

    // Add the dependency for the Google services Gradle plugin
    id("com.google.gms.google-services") version "4.5.0" apply false

}

allprojects {
    repositories {
        google()
        mavenCentral()
        mavenLocal()
    }
}

val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()

subprojects {
    if (project.projectDir.absolutePath.startsWith(rootProject.projectDir.absolutePath)) {
        val subBuildDir = newBuildDir.dir(project.name)
        project.layout.buildDirectory.value(subBuildDir)
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


