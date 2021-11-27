-- | Lifted version of "Control.Concurrent.MVar".
module Effectful.Concurrent.MVar
  ( MVar
  , newEmptyMVar
  , newMVar
  , takeMVar
  , putMVar
  , readMVar
  , swapMVar
  , tryTakeMVar
  , tryPutMVar
  , isEmptyMVar
  , withMVar
  , withMVarMasked
  , modifyMVar
  , modifyMVar_
  , modifyMVarMasked
  , modifyMVarMasked_
  , tryReadMVar
  , mkWeakMVar
  ) where

import System.Mem.Weak (Weak)
import Control.Concurrent.MVar (MVar)
import qualified Control.Concurrent.MVar as M

import Effectful.Concurrent.Effect
import Effectful.Internal.Effect
import Effectful.Internal.Monad

-- | Lifted 'M.newEmptyMVar'.
newEmptyMVar :: Concurrent :> es => Eff es (MVar a)
newEmptyMVar = unsafeEff_ M.newEmptyMVar

-- | Lifted 'M.newMVar'.
newMVar :: Concurrent :> es => a -> Eff es (MVar a)
newMVar = unsafeEff_ . M.newMVar

-- | Lifted 'M.takeMVar'.
takeMVar :: Concurrent :> es => MVar a -> Eff es a
takeMVar = unsafeEff_ . M.takeMVar

-- | Lifted 'M.putMVar'.
putMVar :: Concurrent :> es => MVar a -> a -> Eff es ()
putMVar var = unsafeEff_ . M.putMVar var

-- | Lifted 'M.readMVar'.
readMVar :: Concurrent :> es => MVar a -> Eff es a
readMVar = unsafeEff_ . M.readMVar

-- | Lifted 'M.swapMVar'.
swapMVar :: Concurrent :> es => MVar a -> a -> Eff es a
swapMVar var = unsafeEff_ . M.swapMVar var

-- | Lifted 'M.tryTakeMVar'.
tryTakeMVar :: Concurrent :> es => MVar a -> Eff es (Maybe a)
tryTakeMVar = unsafeEff_ . M.tryTakeMVar

-- | Lifted 'M.tryPutMVar'.
tryPutMVar :: Concurrent :> es => MVar a -> a -> Eff es Bool
tryPutMVar var = unsafeEff_ . M.tryPutMVar var

-- | Lifted 'M.isEmptyMVar'.
isEmptyMVar :: Concurrent :> es => MVar a -> Eff es Bool
isEmptyMVar = unsafeEff_ . M.isEmptyMVar

-- | Lifted 'M.tryReadMVar'.
tryReadMVar :: Concurrent :> es => MVar a -> Eff es (Maybe a)
tryReadMVar = unsafeEff_ . M.tryReadMVar

-- | Lifted 'M.withMVar'.
withMVar :: Concurrent :> es => MVar a -> (a -> Eff es b) -> Eff es b
withMVar var f = unsafeEff $ \es -> M.withMVar var ((`unEff` es) . f)

-- | Lifted 'M.withMVarMasked'.
withMVarMasked :: Concurrent :> es => MVar a -> (a -> Eff es b) -> Eff es b
withMVarMasked var f = unsafeEff $ \es -> M.withMVarMasked var ((`unEff` es) . f)

-- | Lifted 'M.modifyMVar_'.
modifyMVar_ :: Concurrent :> es => MVar a -> (a -> Eff es a) -> Eff es ()
modifyMVar_ var f = unsafeEff $ \es -> M.modifyMVar_ var ((`unEff` es) . f)

-- | Lifted 'M.modifyMVar'.
modifyMVar :: Concurrent :> es => MVar a -> (a -> Eff es (a, b)) -> Eff es b
modifyMVar var f = unsafeEff $ \es -> M.modifyMVar var ((`unEff` es) . f)

-- | Lifted 'M.modifyMVarMasked_'.
modifyMVarMasked_ :: Concurrent :> es => MVar a -> (a -> Eff es a) -> Eff es ()
modifyMVarMasked_ var f = unsafeEff $ \es -> M.modifyMVarMasked_ var ((`unEff` es) . f)

-- | Lifted 'M.modifyMVarMasked'.
modifyMVarMasked :: Concurrent :> es => MVar a -> (a -> Eff es (a, b)) -> Eff es b
modifyMVarMasked var f = unsafeEff $ \es -> M.modifyMVarMasked var ((`unEff` es) . f)

-- | Lifted 'M.mkWeakMVar'.
mkWeakMVar :: Concurrent :> es => MVar a -> Eff es () -> Eff es (Weak (MVar a))
mkWeakMVar var f = unsafeEff $ \es -> M.mkWeakMVar var ((`unEff` es) f)