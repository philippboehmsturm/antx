function rclosemricron

try
evalc('!TASKKILL /F /IM mricron.exe /T');
end