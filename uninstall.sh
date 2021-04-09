export DIALER_PREF=/data/data/com.google.android.dialer/shared_prefs/dialer_phenotype_flags.xml
export GBOARD_PREF=/data/data/com.google.android.inputmethod.latin/shared_prefs/flag_value.xml
export FIT=/data/data/com.google.android.apps.fitness/shared_prefs/growthkit_phenotype_prefs.xml
export GOOGLE_PREF=/data/data/com.google.android.googlequicksearchbox/shared_prefs/GEL.GSAPrefs.xml
export TURBO=/data/data/com.google.android.apps.turbo/shared_prefs/phenotypeFlags.xml

bool_patch() {
file=$2
line=$(grep $1 $2 | grep false | cut -c 14- | cut -d' ' -f1)
for i in $line; do
  val_false='value="true"'
  val_true='value="flase"'
  write="${i} $val_true"
  find="${i} $val_false"
  sed -i -e "s/${find}/${write}/g" $file
done
}

string_patch() {
file=$3
str=$(grep $1 $3 | grep string | cut -c 14- | cut -d'<' -f1)
str1=$(grep $1 $3 | grep string | cut -c 14- | cut -d'>' -f1)
add="$str1>$2"
if [ ! $add == $str ]; then
sed -i -e "s/${str}/${add}/g" $file
fi
}

# Call Screening
bool_patch speak_easy $DIALER_PREF
bool_patch speakeasy $DIALER_PREF
bool_patch call_screen $DIALER_PREF
bool_patch revelio $DIALER_PREF
bool_patch record $DIALER_PREF
bool_patch atlas $DIALER_PREF
bool_patch transript $DIALER_PREF

# GBoard
bool_patch nga $GBOARD_PREF
bool_patch redesign $GBOARD_PREF
bool_patch lens $GBOARD_PREF
bool_patch generation $GBOARD_PREF
bool_patch multiword $GBOARD_PREF
bool_patch promo $GBOARD_PREF
bool_patch enable_email_provider_completion $GBOARD_PREF
bool_patch_false disable_multiword_autocompletion $GBOARD_PREF

#google
chmod 0771 /data/data/com.google.android.googlequicksearchbox/shared_prefs
rm -rf $GOOGLE_PREF

# GoogleFit
bool_patch DeviceStateFeature $FIT
bool_patch TestingFeature $FIT
bool_patch Sync__sync_after_promo_shown $FIT
bool_patch Sync__use_experiment_flag_from_promo $FIT
bool_patch Promotions $FIT

# Turbo
bool_patch AdaptiveCharging__v1_enabled $TURBO

# DevicePersonalization
device_config put device_personalization_services AdaptiveAudio__enable_adaptive_audio false
device_config put device_personalization_services AdaptiveAudio__show_promo_notificatio false
device_config put device_personalization_services Autofill__enable false
device_config put device_personalization_services NotificationAssistant__enable_service false
device_config put device_personalization_services Captions__surface_sound_events false
device_config put device_personalization_services Captions__enable_augmented_music false

# AdaptiveCharging
device_config put adaptive_charging adaptive_charging_enabled false

pm clear com.google.android.dialer