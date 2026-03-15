#!/bin/bash
# gen_dependency.sh
INPUT_FILE="components.txt"
OUTPUT_POM="pom.xml"

cat > "$OUTPUT_POM" <<EOF
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>temp</groupId>
  <artifactId>temp-project</artifactId>
  <version>1.0.0</version>
  <dependencies>
EOF

while IFS=: read -r group artifact version; do
  cat >> "$OUTPUT_POM" <<EOF
    <dependency>
      <groupId>$group</groupId>
      <artifactId>$artifact</artifactId>
      <version>$version</version>
    </dependency>
EOF
done < "$INPUT_FILE"

cat >> "$OUTPUT_POM" <<EOF
  </dependencies>
</project>
EOF

echo "✅ pom.xml 已根據 components.txt 生成完成"
