set -e

(cd Vendor; ./download_dist_tool.sh)

echo "plugin name:"
read PLUGIN_NAME

echo "plugin bundle id:"
read PLUGIN_BUNDLE_IDENTIFIER

DEFAULT_PROJECTS_PATH="/Users/nicholascross/projects"
BASE_PATH="${PROJECTS_PATH:-$DEFAULT_PROJECTS_PATH}"

echo "Creating project ${PLUGIN_NAME}"
mkdir ${BASE_PATH}/${PLUGIN_NAME}

cp project.yml ${BASE_PATH}/${PLUGIN_NAME}

sed -i "" "s/<PLUGIN_NAME>/${PLUGIN_NAME}/g" ${BASE_PATH}/${PLUGIN_NAME}/project.yml
sed -i "" "s/<PLUGIN_BUNDLE_IDENTIFIER>/${PLUGIN_BUNDLE_IDENTIFIER:-$PLUGIN_NAME}/g" ${BASE_PATH}/${PLUGIN_NAME}/project.yml

cp -r Plugin ${BASE_PATH}/${PLUGIN_NAME}/Plugin
cp -r StreamDeckKit ${BASE_PATH}/${PLUGIN_NAME}/StreamDeckKit
cp -r Assets "${BASE_PATH}/${PLUGIN_NAME}/${PLUGIN_BUNDLE_IDENTIFIER}.sdPlugin"
cp -r Vendor ${BASE_PATH}/${PLUGIN_NAME}/Vendor

find ${BASE_PATH}/${PLUGIN_NAME} -name '*.json' -type f | xargs -I '{}' sed -i "" "s/<PLUGIN_NAME>/${PLUGIN_NAME}/g" {}
find ${BASE_PATH}/${PLUGIN_NAME} -name '*.json' -type f | xargs -I '{}' sed -i "" "s/<PLUGIN_BUNDLE_IDENTIFIER>/${PLUGIN_BUNDLE_IDENTIFIER:-$PLUGIN_NAME}/g" {}

find ${BASE_PATH}/${PLUGIN_NAME} -name '*.swift' -type f | xargs -I '{}' sed -i "" "s/<PLUGIN_NAME>/${PLUGIN_NAME}/g" {}
find ${BASE_PATH}/${PLUGIN_NAME} -name '*.swift' -type f | xargs -I '{}' sed -i "" "s/<PLUGIN_BUNDLE_IDENTIFIER>/${PLUGIN_BUNDLE_IDENTIFIER:-$PLUGIN_NAME}/g" {}

xcodegen --project ${BASE_PATH}/${PLUGIN_NAME} -s ${BASE_PATH}/${PLUGIN_NAME}/project.yml
