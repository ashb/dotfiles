function FindProxyForURL(url, host) {
  if (isInNet(myIpAddress(), "10.5.0.0", "255.255.0.0")) {
    // Nap IP range
    return "PROXY " + "10.5.13.30:8080";
  }
  return "DIRECT";
}
