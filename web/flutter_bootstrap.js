{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
  config: { canvasKitBaseUrl: 'canvaskit/' },
  onEntrypointLoaded: async function(engineInitializer) {
    const runner = await engineInitializer.initializeEngine();
    await runner.runApp();
    document.getElementById('document')?.remove();
  }
});
