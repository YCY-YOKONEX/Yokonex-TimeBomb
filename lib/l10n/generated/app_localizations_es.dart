// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Yokonex Time Bomb';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Usar idioma del sistema';

  @override
  String playerDefault(int index) {
    return 'Jugador $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return 'Solo hay $count canales disponibles. Conecta más dispositivos.';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return 'Se probaron $succeeded / $total canales. Revísalos y confírmalos.';
  }

  @override
  String get channelTestSuccess =>
      'Prueba completada. Confirma que el jugador y el canal coinciden.';

  @override
  String get channelTestFailure =>
      'Falló la prueba del canal. Revisa la conexión del dispositivo.';

  @override
  String get completeSafetyTestFirst =>
      'Completa primero la prueba de seguridad de este jugador.';

  @override
  String get playerNameRequired => 'Introduce un nombre para cada jugador.';

  @override
  String get durationInvalid => 'La duración debe ser mayor que 0 segundos.';

  @override
  String get assignmentRequired =>
      'Cada jugador necesita un canal A/B de un dispositivo conectado.';

  @override
  String get assignmentTestRequired =>
      'Cada canal debe superar la prueba de seguridad.';

  @override
  String get assignmentConfirmRequired =>
      'Confirma cada asignación de jugador y canal.';

  @override
  String get connectDevice => 'Conectar dispositivos';

  @override
  String get notConnected => 'Sin conexión';

  @override
  String devicesOnline(int count) {
    return '$count en línea';
  }

  @override
  String get gameSettings => 'Ajustes del juego';

  @override
  String get duration => 'Duración del juego';

  @override
  String get seconds => 's';

  @override
  String get bindPlayers => 'Asignar jugadores';

  @override
  String confirmedCount(int confirmed, int total) {
    return '$confirmed / $total confirmados';
  }

  @override
  String get testingChannels => 'Probando canales';

  @override
  String get autoAssignAndTest => 'Asignar y probar';

  @override
  String get addPlayer => 'Añadir jugador';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return 'Asignados $assigned / $total · Probados $tested / $total · Confirmados $confirmed / $total';
  }

  @override
  String get startIgnition => 'Iniciar encendido';

  @override
  String get deviceNeeded => 'Conecta un dispositivo antes de asignar canales.';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B disponibles';
  }

  @override
  String get searchAndConnect => 'Buscar y conectar dispositivos';

  @override
  String get manageDevices => 'Gestionar dispositivos';

  @override
  String playerHint(int index) {
    return 'Jugador $index';
  }

  @override
  String get removePlayer => 'Eliminar jugador';

  @override
  String get deviceChannel => 'Canal del dispositivo';

  @override
  String get unassigned => 'Sin asignar';

  @override
  String get testing => 'Probando';

  @override
  String get retest => 'Probar de nuevo';

  @override
  String get safetyTest => 'Prueba de seguridad';

  @override
  String get confirmed => 'Confirmado';

  @override
  String get confirmAssignment => 'Confirmar';

  @override
  String get punishmentDevices => 'Dispositivos de castigo';

  @override
  String get stopAll => 'Detener todo';

  @override
  String get searching => 'Buscando';

  @override
  String get searchAgain => 'Buscar de nuevo';

  @override
  String connectionSummary(int devices, int channels) {
    return '$devices conectados · $channels canales disponibles';
  }

  @override
  String get turnOnDevices =>
      'Enciende un dispositivo y mantenlo cerca del teléfono.';

  @override
  String get connecting => 'Conectando';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get connect => 'Conectar';

  @override
  String get firstGeneration => '1.ª generación';

  @override
  String get secondGeneration => '2.ª generación';

  @override
  String channelLabel(String name, String channel) {
    return '$name · Canal $channel';
  }

  @override
  String connectionFailed(String detail) {
    return 'Error de conexión: $detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return 'Falló la prueba de onda: $detail';
  }

  @override
  String triggerFailed(String detail) {
    return 'Falló la activación: $detail';
  }

  @override
  String stopFailed(String detail) {
    return 'Falló la detención: $detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return 'Falló la parada de emergencia: $detail';
  }

  @override
  String get triggeringDevice => 'Activando dispositivo de castigo…';

  @override
  String get minimumGrams => 'Añade al menos 1 gramo por turno.';

  @override
  String remainingGramsLimit(int grams) {
    return 'Puedes añadir hasta $grams gramos más.';
  }

  @override
  String loadBomb(int grams) {
    return 'Cargando bomba de $grams g';
  }

  @override
  String addNumbSeasoning(int count) {
    return 'Añadiendo efecto adormecedor ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return 'Añadiendo picante ×$count';
  }

  @override
  String get keepOriginal => 'Manteniendo el sabor original';

  @override
  String get sealed => 'Bomba sellada';

  @override
  String get playerHasNoDevice =>
      'Este jugador no tiene un dispositivo asignado.';

  @override
  String devicesTriggered(int count) {
    return '$count dispositivo(s) activado(s)';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return '$succeeded / $attempted dispositivos activados';
  }

  @override
  String get exitGame => 'Salir del juego';

  @override
  String playerPosition(int current, int total) {
    return 'Jugador $current / $total';
  }

  @override
  String get currentPlayer => 'Jugador actual';

  @override
  String get pauseAndPass => 'Pausar y pasar';

  @override
  String get readyToTakeOver => 'Prepárate';

  @override
  String get readyToIgnite => 'Listo para encender';

  @override
  String get handPhoneTo => 'Entrega el teléfono a';

  @override
  String get remainingTime => 'Tiempo restante';

  @override
  String remainingTimeSemantics(String time) {
    return 'Tiempo restante $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return 'Bomba total: $grams g · $flavor';
  }

  @override
  String get seasoningPromptTitle => 'A esta bomba le falta intensidad';

  @override
  String get seasoningPromptBody =>
      'Cada gramo y sabor se queda para el siguiente jugador.';

  @override
  String get addGramsThisTurn => 'Gramos para añadir';

  @override
  String get grams => 'g';

  @override
  String get addNumb => 'Añadir adormecedor';

  @override
  String get addSpicy => 'Añadir picante';

  @override
  String get takeBomb => 'Recibir la bomba';

  @override
  String get addingSeasoning => 'Añadiendo condimentos';

  @override
  String get boom => '¡BUM!';

  @override
  String get takePunishment => 'Recibe el castigo';

  @override
  String bombResult(int grams, String flavor) {
    return '$grams g · $flavor';
  }

  @override
  String get playAgain => 'Jugar otra vez';

  @override
  String get resetGame => 'Cambiar ajustes';

  @override
  String get exitRoundTitle => '¿Salir de esta partida?';

  @override
  String get exitRoundBody => 'Se perderá la cuenta atrás actual.';

  @override
  String get continueGame => 'Seguir jugando';

  @override
  String get exit => 'Salir';

  @override
  String get originalFlavor => 'Original';

  @override
  String get numbFlavor => 'Adormecedor';

  @override
  String numbFlavorCount(int count) {
    return 'Adormecedor ×$count';
  }

  @override
  String get spicyFlavor => 'Picante';

  @override
  String spicyFlavorCount(int count) {
    return 'Picante ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return 'Adormecedor ×$numb · Picante ×$spicy';
  }
}
