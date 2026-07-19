buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 1. Configure compileSdkVersion and cleanManifest before any project evaluation happens
subprojects {
    val cleanManifestAndSetup = {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val getNamespace = android.javaClass.methods.firstOrNull { it.name == "getNamespace" && it.parameterCount == 0 }
                    val namespace = getNamespace?.invoke(android) as? String
                    if (namespace == null || namespace.isEmpty()) {
                        val setNamespace = android.javaClass.methods.firstOrNull { it.name == "setNamespace" && it.parameterCount == 1 && it.parameterTypes[0] == String::class.java }
                        setNamespace?.invoke(android, "com.example.${project.name.replace("-", "_")}")
                    }
                } catch (e: Exception) {
                    // Ignore reflection errors if any
                }
                
                val manifestFile = project.file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    try {
                        var content = manifestFile.readText()
                        if (content.contains("package=")) {
                            content = content.replace(Regex("package=\"[^\"]*\""), "")
                            manifestFile.writeText(content)
                        }
                    } catch (e: Exception) {
                        // Ignore manifest write errors
                    }
                }
            }
        }
    }

    val configureCompileSdk = {
        if (extensions.findByName("android") != null) {
            extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                compileSdkVersion(36)
            }
        }
    }

    if (project.state.executed) {
        cleanManifestAndSetup()
        configureCompileSdk()
    } else {
        project.afterEvaluate {
            cleanManifestAndSetup()
            configureCompileSdk()
        }
    }
}

// 2. Trigger evaluation of app module (and transitive dependencies) after setup listeners are registered
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}