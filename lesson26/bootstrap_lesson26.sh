#!/usr/bin/env bash
set -euo pipefail

mkapp () {
  local dir="$1"
  local title="$2"
  local msg="$3"

  mkdir -p "lesson26/apps/$dir/src/main/java/ru/codeby"
  mkdir -p "lesson26/apps/$dir/src/test/java/ru/codeby"

  cat > "lesson26/apps/$dir/pom.xml" <<POM
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>ru.codeby</groupId>
  <artifactId>${dir}</artifactId>
  <version>1.0.0</version>
  <packaging>jar</packaging>

  <properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>

  <dependencies>
    <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter</artifactId>
      <version>5.10.2</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>3.2.5</version>
      </plugin>

      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
        <version>3.4.2</version>
        <configuration>
          <archive>
            <manifest>
              <mainClass>ru.codeby.App</mainClass>
            </manifest>
          </archive>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
POM

  cat > "lesson26/apps/$dir/src/main/java/ru/codeby/App.java" <<JAVA
package ru.codeby;

public class App {
    public static String message() {
        return "${msg}";
    }

    public static void main(String[] args) {
        System.out.println(message());
    }
}
JAVA

  cat > "lesson26/apps/$dir/src/test/java/ru/codeby/AppTest.java" <<JAVA
package ru.codeby;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class AppTest {
    @Test
    void messageIsCorrect() {
        assertEquals("${msg}", App.message());
    }
}
JAVA

  echo "Created $title in lesson26/apps/$dir"
}

mkapp "hello-world"   "Hello World"   "Hello World!"
mkapp "hello-jenkins" "Hello Jenkins" "Hello Jenkins!"
mkapp "hello-devops"  "Hello Devops"  "Hello Devops!"

echo "✅ Apps created."
