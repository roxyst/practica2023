{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_practica2023 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "C:\\Users\\roxan\\practica2023\\.stack-work\\install\\41cd3d26\\bin"
libdir     = "C:\\Users\\roxan\\practica2023\\.stack-work\\install\\41cd3d26\\lib\\x86_64-windows-ghc-9.2.5\\practica2023-0.1.0.0-GqqPj0ZUiVz4u09abn6BmK"
dynlibdir  = "C:\\Users\\roxan\\practica2023\\.stack-work\\install\\41cd3d26\\lib\\x86_64-windows-ghc-9.2.5"
datadir    = "C:\\Users\\roxan\\practica2023\\.stack-work\\install\\41cd3d26\\share\\x86_64-windows-ghc-9.2.5\\practica2023-0.1.0.0"
libexecdir = "C:\\Users\\roxan\\practica2023\\.stack-work\\install\\41cd3d26\\libexec\\x86_64-windows-ghc-9.2.5\\practica2023-0.1.0.0"
sysconfdir = "C:\\Users\\roxan\\practica2023\\.stack-work\\install\\41cd3d26\\etc"

getBinDir     = catchIO (getEnv "practica2023_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "practica2023_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "practica2023_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "practica2023_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "practica2023_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "practica2023_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '\\'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/' || c == '\\'
