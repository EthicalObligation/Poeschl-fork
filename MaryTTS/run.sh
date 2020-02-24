#!/usr/bin/env bashio
set -e

bashio::log.info 'Setup voice'
if [ -n "$(bashio::config 'voice')" ] && [ ! "$(bashio::config 'voice')" == 'null' ]; then
	bashio::log.info 'Using custom voice pack!'
	voice_pack=$(bashio::config 'voice')
else
	if [ "$(bashio::config 'language')" == 'de' ]; then
		voice_pack="https://github.com/marytts/voice-dfki-pavoque-neutral-hsmm/releases/download/v${MARYTTS_VERSION}/voice-dfki-pavoque-neutral-hsmm-${MARYTTS_VERSION}.zip"
	elif [ "$(bashio::config 'language')" == 'en' ]; then
		voice_pack="https://github.com/marytts/voice-cmu-slt-hsmm/releases/download/v${MARYTTS_VERSION}/voice-cmu-slt-hsmm-${MARYTTS_VERSION}.zip"
	elif [ "$(bashio::config 'language')" == 'fr' ]; then
		voice_pack="https://github.com/marytts/voice-enst-camille-hsmm/releases/download/v${MARYTTS_VERSION}/voice-enst-camille-hsmm-${MARYTTS_VERSION}.zip"
	elif [ "$(bashio::config 'language')" == 'it' ]; then
		voice_pack="https://github.com/marytts/voice-istc-lucia-hsmm/releases/download/v${MARYTTS_VERSION}/voice-istc-lucia-hsmm-${MARYTTS_VERSION}.zip"
	elif [ "$(bashio::config 'language')" == 'in' ]; then
		voice_pack="https://github.com/marytts/voice-cmu-nk-hsmm/releases/download/v${MARYTTS_VERSION}/voice-cmu-nk-hsmm-${MARYTTS_VERSION}.zip"
	elif [ "$(bashio::config 'language')" == 'tu' ]; then
		voice_pack="https://github.com/marytts/voice-dfki-ot-hsmm/releases/download/v${MARYTTS_VERSION}/voice-dfki-ot-hsmm-${MARYTTS_VERSION}.zip"
	elif [ "$(bashio::config 'language')" == 'lu' ]; then
		voice_pack="https://github.com/marytts/voice-marylux-lb/releases/download/v${MARYTTS_VERSION}/voice-marylux-lb-${MARYTTS_VERSION}.zip"
	fi
fi

voice_pack_full_name="$(basename -- "$voice_pack")"
voice_pack_name=${voice_pack_full_name%.zip}

if [ ! -f "/app/lib/${voice_pack_name}.jar" ]; then
	bashio::log.info "Downloading ${voice_pack_name}..."
	wget -P /tmp -q "$voice_pack"

	unzip "/tmp/${voice_pack_full_name}" -d /tmp
	mv "/tmp/lib/${voice_pack_name}.jar" /app/lib

	bashio::log.info "Installed $voice_pack_name"
fi

bashio::log.info 'Start MaryTTS'
bin/marytts-server
