NAME            SERVICE-MESH                              PROXY-READINESS                                             SERVICE-ACCT
.metadata.name  .metadata.annotations.linkerd\.io/inject  .status.containerStatuses[?(@.name=="linkerd-proxy")].ready .spec.serviceAccountName
